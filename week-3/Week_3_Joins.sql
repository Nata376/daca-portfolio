
-- Kustuta duplikaadid sales tabelist (sama loogika mis W2 sales_test peal)
DELETE FROM sales
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales
    GROUP BY sale_id
);

-- Paranda tuleviku kuupäevad
UPDATE sales
SET sale_date = CURRENT_DATE
WHERE sale_date > CURRENT_DATE;

-- Ühtlusta klientide linnanimed (muidu GROUP BY city näitab 50+ varianti 12 asemel)
UPDATE customers
SET city = INITCAP(TRIM(city))
WHERE city IS NOT NULL;

-- Kontrolli tulemusi
SELECT COUNT(*) AS sales_ridu FROM sales;  
SELECT COUNT(DISTINCT city) AS linnu FROM customers;

SELECT
    c.first_name,
    c.last_name,
    c.city,
    s.sale_id,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.total_price DESC
LIMIT 10;

-- INNER JOIN: kliendid koos nende müükidega
SELECT
    c.first_name,
    c.last_name,
    c.city,
    s.sale_id,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.total_price DESC
LIMIT 20;

-- INNER JOIN: tooted koos müüdud kogustega
SELECT
    p.product_name,
    p.category,
    s.quantity,
    s.unit_price
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY s.quantity DESC
LIMIT 15;

UrbanStyle näide — kõik kliendid, ka need kes pole ostnud:
SELECT
    c.first_name,
    c.last_name,
    c.city,
    s.sale_id,
    s.total_price
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
ORDER BY s.total_price DESC NULLS LAST;

-- Kliendid, kes pole KUNAGI ostnud
SELECT
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.registration_date
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;

-- Kadunud kliendid: LEFT JOIN + WHERE IS NULL
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nimi,
    c.email,
    c.city,
    c.registration_date
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
ORDER BY c.registration_date DESC;

-- Võrdluseks: INNER JOIN (ainult aktiivsed kliendid)
SELECT COUNT(DISTINCT c.customer_id) AS aktiivseid_kliente
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id;

Millised tooted on meie kataloogis, aga neid pole kunagi müüdud
SELECT p.product_name, 
       p.category, 
       p.retail_price
FROM products p
LEFT JOIN sales s 
       ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;

-- LEFT JOIN (kõik kliendid):
SELECT c.first_name, s.sale_id
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id;

-- RIGHT JOIN (sama tulemus, aga tabelid vastupidi):
SELECT c.first_name, s.sale_id
FROM sales s
RIGHT JOIN customers c ON s.customer_id = c.customer_id;

SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city,
    s.sale_date,
    s.total_price,
    p.product_name,
    p.category,
    s.quantity,
    s.unit_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY s.total_price DESC
LIMIT 20;

-- 3 tabeli JOIN: kes ostis mida?
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city AS linn,
    s.sale_date AS müügi_kuupäev,
    p.product_name AS toode,
    p.category AS kategooria,
    s.quantity AS kogus,
    s.unit_price AS ühikuhind,
    s.total_price AS rea_summa
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY rea_summa DESC
LIMIT 20;

Millised tootekategooriad müüvad igas linnas kõige rohkem?
SELECT 
    c.city, 
    p.category, 
    SUM(s.total_price) AS total_sales
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
GROUP BY 
    c.city, 
    p.category
ORDER BY 
    c.city ASC, 
    total_sales DESC;

TOP 20 klienti koos tootekategooriatega
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city AS linn,
    p.category AS kategooria,
    SUM(s.total_price) AS kogumuuk
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, p.category
ORDER BY kogumuuk DESC
LIMIT 20;

Kadunud kliendid linnade kaupa
SELECT
    c.city AS linn,
    COUNT(*) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY c.city
ORDER BY kadunud_kliente DESC;

SELECT
    p.category AS kategooria,
    COUNT(*) AS müümata_tooteid,
    ROUND(AVG(p.retail_price), 2) AS keskmine_hind
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
GROUP BY p.category
ORDER BY müümata_tooteid DESC;SELECT
    p.category AS kategooria,
    COUNT(*) AS müümata_tooteid,
    ROUND(AVG(p.retail_price), 2) AS keskmine_hind
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
GROUP BY p.category
ORDER BY müümata_tooteid DESC;

Müümata tooted kategooriate kaupa
SELECT
    p.category AS kategooria,
    COUNT(*) AS müümata_tooteid,
    ROUND(AVG(p.retail_price), 2) AS keskmine_hind
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
GROUP BY p.category
ORDER BY müümata_tooteid DESC;
