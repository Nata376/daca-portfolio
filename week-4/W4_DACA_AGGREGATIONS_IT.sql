-- 1A Müük kuude kaupa 2024. aastal
SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS kuu,
    COUNT(*) AS tellimusi,
    SUM(total_price) AS käive,
    ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31 23:59:59'
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY kuu;

-- 1B: Müük linnade kaupa
SELECT 
    c.city AS linn,
    COUNT(s.sale_id) AS tellimuste_arv, -- või COUNT(*)
    SUM(s.total_price) AS kogukäive,
    ROUND(AVG(s.total_price), 2) AS keskmine_tellimus
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY kogukäive DESC;

-- 1C Müük nädalapäevade kaupa
SELECT 
    TO_CHAR(sale_date, 'Day') AS nädalapäev,
    EXTRACT(ISODOW FROM sale_date) AS päeva_nr,
    COUNT(*) AS tellimuste_arv,
    SUM(total_price) AS kogukäive,
    ROUND(AVG(total_price), 2) AS keskmine_ost
FROM sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY TO_CHAR(sale_date, 'Day'), EXTRACT(ISODOW FROM sale_date)
ORDER BY päeva_nr; 

--2A  leia kliendid, kes on ostnud üle 500€:
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nimi,
    COUNT(s.sale_id) AS tellimuste_arv,
    SUM(s.total_price) AS kogukäive
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(s.total_price) > 500
ORDER BY kogukäive DESC;

--2B Liisi varude audit (kategooriad, kus on müüdud üle 500 ühiku)
SELECT 
    p.category AS kategooria,
    SUM(s.quantity) AS müüdud_kogus,
    ROUND(AVG(p.retail_price), 2) AS keskmine_jaemüük,
    COUNT(DISTINCT p.product_id) AS erisuguste_toodete_arv
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
HAVING SUM(s.quantity) > 500
ORDER BY müüdud_kogus DESC;

--2C 2024. aasta Q1 müük kuude kaupa, kus käive ületab 5000 €
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS kuu,                          -- Muudab kuupäeva formaati 'AASTA-KUU' kujule (nt "2024-01")
    COUNT(*) AS tellimuste_arv,                                     -- Loendab kokku selle kuu tehingute üldarvu
    SUM(total_price) AS kogukäive,                                  -- Liidab kokku kõigi selle kuu tehingute summad (kuu kogukäive)
    ROUND(AVG(total_price), 2) AS keskmine_ost                     -- Arvutab kuu keskmise ostukorvi ja ümardab selle 2 komakohani
FROM sales                                                         -- Määrab allikaks müügiandmete tabeli (sales)
WHERE sale_date BETWEEN '2024-01-01' AND '2024-03-31 23:59:59'     -- Rea-taseme filter: võtab arvesse AINULT 2024. aasta Q1 tehingud (enne grupeerimist)
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')                             -- Grupeerib allesjäänud read aasta ja kuu kaupa
HAVING SUM(total_price) > 5000                                     -- Grupi-taseme filter: jätab alles ainult need kuud, kus KOKKU oli käive üle 5000 €
ORDER BY kuu;        

--3A CTE päring mis arvutab  kuu käive ja kasv.
WITH kuu_myyk AS (                                                         -- Algatab ajutise vahetabeli (CTE) nimega "kuu_myyk"
    SELECT
        DATE_TRUNC('month', sale_date) AS kuu,                             -- Ümardab kuupäeva kuu algusesse (nt "2024-01-15" muutub "2024-01-01 00:00:00")
        SUM(total_price) AS käive                                           -- Liidab kokku iga kuu kõigi tehingute summad (kuu kogukäive)
    FROM sales                                                             -- Määrab andmete allikaks "sales" tabeli
    WHERE sale_date >= '2024-01-01'                                        -- Filtreerib välja tehingud alates 1. jaanuarist 2024
    GROUP BY DATE_TRUNC('month', sale_date)                                -- Grupeerib andmed ümardatud kuude kaupa, et SUM arvutaks iga kuu käibe eraldi
)                                                                          -- Sulgeb ajutise tabeli "kuu_myyk" definitsiooni
SELECT
    kuu,                                                                   -- Kuvab vahetabelist kuu alguskuupäeva
    käive,                                                                 -- Kuvab vahetabelist selle kuu kogukäibe
    LAG(käive) OVER (ORDER BY kuu) AS eelmine_kuu,                        -- Aknafunktsioon (window function): võtab kronoloogiliselt EELMISE kuu käibe
    käive - LAG(käive) OVER (ORDER BY kuu) AS kasv,                       -- Arvutab käibe rahalise kasvu/kahanemise võrreldes eelmise kuuga (praegune kuu - eelmine kuu)
    ROUND(                                                                 -- Ümardab järgneva arvutuse tulemuse
        100.0 * (käive - LAG(käive) OVER (ORDER BY kuu)) 
        / LAG(käive) OVER (ORDER BY kuu), 1                                -- Arvutab käibe kasvu protsentides: ((kasv / eelmine_kuu) * 100) ning ümardab 1 komakohani
    ) AS kasv_protsent                                                    -- Paneb arvutatud protsendile veerupealkirjaks "kasv_protsent"
FROM kuu_myyk                                                              -- Võtab andmed alguses loodud ajutisest vahetabelist "kuu_myyk"
ORDER BY kuu;                                                              -- Sorteerib lõpptulemuse kuude järgi varasemast hilisemani

--(isiklikke huve toitev harjutus)
WITH kliendi_kuu_myyk AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', sale_date) AS kuu,
        SUM(total_price) AS käive
    FROM sales
    WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31 23:59:59'
      AND customer_id IS NOT NULL
    GROUP BY customer_id, DATE_TRUNC('month', sale_date)
)
SELECT
    customer_id,
    TO_CHAR(kuu, 'YYYY-MM') AS kuu,
    käive,
    -- COALESCE muutub NULL väärtuse 0-ks
    COALESCE(LAG(käive) OVER (PARTITION BY customer_id ORDER BY kuu), 0) AS eelmine_kuu,
    
    -- Kasv arvutatakse nüüd nii: käive - 0
    käive - COALESCE(LAG(käive) OVER (PARTITION BY customer_id ORDER BY kuu), 0) AS kasv,
    
    -- Kui eelmine kuu oli 0 (või puudus), kuvatakse protsendina NULL (et vältida 0-ga jagamise viga)
    CASE 
        WHEN COALESCE(LAG(käive) OVER (PARTITION BY customer_id ORDER BY kuu), 0) = 0 THEN NULL
        ELSE ROUND(
            100.0 * (käive - LAG(käive) OVER (PARTITION BY customer_id ORDER BY kuu)) 
            / LAG(käive) OVER (PARTITION BY customer_id ORDER BY kuu), 1
        )
    END AS kasv_protsent
FROM kliendi_kuu_myyk
ORDER BY customer_id, kuu;

--3B CTE-põhine päring, mis segmenteerib kliendid VIP / Aktiivne / Tavaline 
WITH kliendi_kokkuvote AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(s.sale_id) AS tellimuste_arv,
        COALESCE(SUM(s.total_price), 0) AS kogukaive       -- Asendab tehinguteta klientide NULL-i 0-ga
    FROM customers c
    LEFT JOIN sales s ON c.customer_id = s.customer_id     -- LEFT JOIN võtab KÕIK 3150 klienti tabelist customers
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
),
kliendi_segmentatsioon AS (
    SELECT
        customer_id,
        nimi,
        city,
        tellimuste_arv,
        kogukaive,
        CASE
            WHEN kogukaive > 3000 THEN 'VIP'
            WHEN kogukaive > 1000 THEN 'Aktiivne'
            WHEN kogukaive > 0 THEN 'Tavaline'
            ELSE 'Ostuta / Inaktiivne'                     -- Saab eraldi tähise neile 599 kliendile
        END AS segment
    FROM kliendi_kokkuvote
)
SELECT
    segment,
    COUNT(*) AS klientide_arv,
    ROUND(AVG(kogukaive), 2) AS keskmine_segmendi_kaive,
    SUM(kogukaive) AS segmendi_kogukaive
FROM kliendi_segmentatsioon
GROUP BY segment
ORDER BY segmendi_kogukaive DESC;

--3C iga kategooria TOP 3 toodet
WITH toodete_myyk AS (
    SELECT 
        p.category AS kategooria,                                        -- Toote kategooria
        p.product_name AS toote_nimi,                                    -- Toote nimi
        SUM(s.quantity) AS myydud_kogus,                                 -- Arvutab toote müüdud ühikute koguarvu
        ROW_NUMBER() OVER (
            PARTITION BY p.category                                      -- Taaskäivitab numeratsiooni iga uue kategooria puhul
            ORDER BY SUM(s.quantity) DESC                                -- Sorteerib tooted kategooria sees koguse järgi kahanevalt
        ) AS koht                                                       -- Omistab järjestikuse kohanumbri (1, 2, 3...)
    FROM sales s
    JOIN products p ON s.product_id = p.product_id                      -- Ühendab müügirida ja toodete tabeli
    GROUP BY p.category, p.product_name                                 -- Grupeerib andmed toote ja kategooria kaupa
)
SELECT 
    kategooria,
    koht,
    toote_nimi,
    myydud_kogus
FROM toodete_myyk
WHERE koht <= 3                                                         -- Jätab alles ainult iga kategooria TOP 3 tooted
ORDER BY kategooria, koht;                            


-- Kvartali tulemused: 

WITH linna_myyk AS (
    -- CTE 1: Arvutab iga linna kogumuugid ja jagab kuupõhised summad
    SELECT
        c.city AS linn,
        COUNT(DISTINCT s.sale_id) AS tellimusi,
        SUM(s.total_price) AS kogukaive,
        ROUND(AVG(s.total_price), 2) AS keskmine_tellimus,
        
        -- Lisa 1: Viimase kuu (detsember 2024) käive
        SUM(CASE WHEN TO_CHAR(s.sale_date, 'YYYY-MM') = '2024-12' THEN s.total_price ELSE 0 END) AS viimase_kuu_kaive,
        
        -- Lisa 2: Ülejäänud 11 kuu keskmine käive
        ROUND(SUM(CASE WHEN TO_CHAR(s.sale_date, 'YYYY-MM') < '2024-12' THEN s.total_price ELSE 0 END) / 11.0, 2) AS eelmiste_kuude_keskmine
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    WHERE s.sale_date BETWEEN '2024-01-01' AND '2024-12-31 23:59:59'
    GROUP BY c.city
    HAVING COUNT(DISTINCT s.sale_id) > 5
),
linna_jarjestus AS (
    -- CTE 2: Arvutab järjestuse ja linna osakaalu kogu ettevõtte käibest
    SELECT
        linn,
        tellimusi,
        kogukaive,
        -- Aknafunktsioon arvutab linna käibe osakaalu KÕIKIDE linnade kogukäibest
        ROUND(100.0 * kogukaive / SUM(kogukaive) OVER (), 1) AS osakaal_protsent,
        keskmine_tellimus,
        viimase_kuu_kaive,
        eelmiste_kuude_keskmine,
        ROW_NUMBER() OVER (ORDER BY kogukaive DESC) AS koht
    FROM linna_myyk
)
SELECT
    koht,
    linn,
    tellimusi,
    kogukaive,
    osakaal_protsent,
    keskmine_tellimus,
    viimase_kuu_kaive,
    eelmiste_kuude_keskmine
FROM linna_jarjestus
WHERE koht <= 5
ORDER BY koht;