-- 1. Müük kuude kaupa (2024)
SELECT 
    DATE_TRUNC('month', sale_date) AS kuu,
    COUNT(sale_id) AS tellimuste_arv,
    SUM(total_price) AS kogukäive,
    ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
WHERE sale_date >= '2024-01-01' AND sale_date < '2025-01-01'
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY kuu;

-- 2. Müük kategooriate kaupa
SELECT 
    p.category AS kategooria,
    SUM(s.quantity) AS toodete_müüdud_kogus,
    SUM(s.total_price) AS kogumüük,
    ROUND(AVG(s.unit_price), 2) AS keskmine_hind
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
HAVING SUM(s.total_price) > 500
ORDER BY kogumüük DESC;

-- 3. Kuised trendid ja kasvu protsent (CTE + LAG())
WITH kuu_myyk AS (
    SELECT 
        DATE_TRUNC('month', sale_date) AS kuu,
        SUM(total_price) AS käive
    FROM sales
    WHERE sale_date >= '2024-01-01' AND sale_date < '2025-01-01'
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT 
    kuu,
    käive,
    LAG(käive) OVER (ORDER BY kuu) AS eelmine_kuu,
    käive - LAG(käive) OVER (ORDER BY kuu) AS absoluutne_muutus,
    ROUND(
        (käive - LAG(käive) OVER (ORDER BY kuu)) 
        / NULLIF(LAG(käive) OVER (ORDER BY kuu), 0) * 100, 1
    ) AS kasvu_protsent
FROM kuu_myyk
ORDER BY kuu;



-- ROLL B: Kliendigruppide analüüs


-- 1. Kliendigruppide analüüs ja järjestus linnas (CTE + CASE WHEN + RANK())
WITH kliendi_kokkuvote AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(o.sale_id) AS tellimuste_arv,
        SUM(o.total_price) AS kogukäive
    FROM customers c
    JOIN sales o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
SELECT 
    nimi,
    city,
    tellimuste_arv,
    kogukäive,
    CASE 
        WHEN kogukäive > 500 THEN 'VIP'
        WHEN kogukäive >= 150 THEN 'Regular'
        ELSE 'Uus'
    END AS segment,
    RANK() OVER (
        PARTITION BY city 
        ORDER BY kogukäive DESC
    ) AS koht_linnas
FROM kliendi_kokkuvote
ORDER BY kogukäive DESC;

-- 2. TOP 10 klienti (mitme ostuga kliendid)
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nimi,
    c.city,
    COUNT(o.sale_id) AS tellimuste_arv,
    SUM(o.total_price) AS kogukäive
FROM customers c
JOIN sales o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
HAVING COUNT(o.sale_id) >= 2
ORDER BY kogukäive DESC
LIMIT 10;

-- 3. Segmentide koondstatistika ja linnade jaotus
WITH kliendi_kokkuvote AS (
    SELECT 
        c.customer_id,
        c.city,
        SUM(o.total_price) AS kogukäive
    FROM customers c
    JOIN sales o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.city
),
segmenteeritud_kliendid AS (
    SELECT 
        customer_id,
        city,
        kogukäive,
        CASE 
            WHEN kogukäive > 500 THEN 'VIP'
            WHEN kogukäive >= 150 THEN 'Regular'
            ELSE 'Uus'
        END AS segment
    FROM kliendi_kokkuvote
)
SELECT 
    segment,
    COUNT(customer_id) AS klientide_arv,
    ROUND(AVG(kogukäive), 2) AS keskmine_käive,
    MODE() WITHIN GROUP (ORDER BY city) AS peamine_linn
FROM segmenteeritud_kliendid
GROUP BY segment
ORDER BY keskmine_käive DESC;



-- ROLL C: Inventuuristatistika


-- 1. Tootekategooriate koondandmed
SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) AS tooteid,
    ROUND(AVG(p.retail_price), 2) AS keskmine_hind,
    MIN(p.retail_price) AS min_hind,
    MAX(p.retail_price) AS max_hind
FROM products p
GROUP BY p.category
ORDER BY tooteid DESC;

-- 2. Müüdud mahud kategooriate kaupa (JOIN + HAVING)
SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) AS erinevaid_tooteid,
    SUM(s.quantity) AS kokku_müüdud_kogus,
    ROUND(AVG(s.quantity), 2) AS keskmine_müük_tehingus,
    SUM(s.total_price) AS kategooria_kogukäive
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category
HAVING SUM(s.quantity) > 100
ORDER BY kokku_müüdud_kogus DESC;

-- 3. TOP 3 kallimat/populaarsemat toodet iga kategooria sees (Window Function + CTE)
WITH kategooria_jarjestus AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        p.retail_price,
        COALESCE(SUM(s.quantity), 0) AS müüdud_kogus,
        ROW_NUMBER() OVER (
            PARTITION BY p.category 
            ORDER BY p.retail_price DESC
        ) AS koht_kategoorias
    FROM products p
    LEFT JOIN sales s ON p.product_id = s.product_id
    GROUP BY p.product_id, p.product_name, p.category, p.retail_price
)
SELECT 
    product_name,
    category,
    retail_price,
    müüdud_kogus,
    koht_kategoorias
FROM kategooria_jarjestus
WHERE koht_kategoorias <= 3
ORDER BY category, koht_kategoorias;



-- ROLL D: Turunduskampaaniate ROI ja kanali efektiivsus (KORRIGEERITUD)

-- 1. Turunduskanali koondandmed
WITH kliendi_kanal AS (
    SELECT DISTINCT ON (customer_id)
        customer_id,
        COALESCE(source, 'Teadmata / Otse') AS turunduskanal
    FROM web_logs
    ORDER BY customer_id, visit_date DESC
)
SELECT 
    k.turunduskanal,
    COUNT(DISTINCT o.customer_id) AS kliente,
    COUNT(DISTINCT o.sale_id) AS tellimusi,
    SUM(o.total_price) AS kogukäive,
    ROUND(AVG(o.total_price), 2) AS keskmine_tellimus
FROM sales o
LEFT JOIN kliendi_kanal k ON o.customer_id = k.customer_id
GROUP BY k.turunduskanal
ORDER BY kogukäive DESC;


-- 2. Kanali efektiivsuse arvutamine
WITH kliendi_kanal AS (
    SELECT DISTINCT ON (customer_id)
        customer_id,
        COALESCE(source, 'Teadmata / Otse') AS turunduskanal
    FROM web_logs
    ORDER BY customer_id, visit_date DESC
),
kanali_myyk AS (
    SELECT 
        k.turunduskanal,
        COUNT(DISTINCT o.sale_id) AS tellimuste_arv,
        SUM(o.total_price) AS kogukäive
    FROM sales o
    LEFT JOIN kliendi_kanal k ON o.customer_id = k.customer_id
    GROUP BY k.turunduskanal
),
kanali_kliendid AS (
    SELECT 
        k.turunduskanal,
        COUNT(DISTINCT c.customer_id) AS klientide_arv
    FROM customers c
    LEFT JOIN kliendi_kanal k ON c.customer_id = k.customer_id
    GROUP BY k.turunduskanal
)
SELECT 
    m.turunduskanal,
    k.klientide_arv,
    m.tellimuste_arv,
    m.kogukäive,
    ROUND(m.kogukäive / NULLIF(k.klientide_arv, 0), 2) AS käive_per_klient
FROM kanali_myyk m
JOIN kanali_kliendid k ON m.turunduskanal = k.turunduskanal
ORDER BY käive_per_klient DESC;


-- 3. Kampaaniate kuised trendid ja kasv
WITH kliendi_kanal AS (
    SELECT DISTINCT ON (customer_id)
        customer_id,
        COALESCE(source, 'Teadmata / Otse') AS turunduskanal
    FROM web_logs
    ORDER BY customer_id, visit_date DESC
),
kuine_kanali_myyk AS (
    SELECT 
        k.turunduskanal,
        DATE_TRUNC('month', o.sale_date) AS kuu,
        COUNT(DISTINCT o.sale_id) AS tellimusi,
        COUNT(DISTINCT o.customer_id) AS kliente,
        SUM(o.total_price) AS kogukäive
    FROM sales o
    LEFT JOIN kliendi_kanal k ON o.customer_id = k.customer_id
    GROUP BY k.turunduskanal, DATE_TRUNC('month', o.sale_date)
)
SELECT 
    turunduskanal,
    kuu,
    kliente,
    tellimusi,
    kogukäive,
    LAG(kogukäive) OVER (
        PARTITION BY turunduskanal 
        ORDER BY kuu
    ) AS eelmise_kuu_käive,
    kogukäive - LAG(kogukäive) OVER (
        PARTITION BY turunduskanal 
        ORDER BY kuu
    ) AS kuine_muutus
FROM kuine_kanali_myyk
ORDER BY turunduskanal, kuu ASC;