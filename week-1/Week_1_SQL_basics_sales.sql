
-- 1. ÜLDINE KOONDTABEL (asendab üksikud COUNT päringud)

-- Koondülevaade kõigi tabelite ridade arvust
SELECT 'products' AS tabel, COUNT(*) AS ridu FROM products
UNION ALL 
SELECT 'customers', COUNT(*) FROM customers
UNION ALL 
SELECT 'sales', COUNT(*) FROM sales;


-- 2. MÜÜGIANDMETE VALIK, VEERGUDE ÜMBERNIMETAMINE JA PIPERDAMINE

-- Täielik näide veergude ümbernimetamisest ja sorteerimisest
SELECT
    customer_id AS klient,
    total_price AS summa,
    sale_date AS kuupäev
FROM sales
ORDER BY total_price DESC
LIMIT 10;

-- 5 väiksemat müüki (Iseseisev harjutus 1B)
SELECT sale_id, total_price AS SUMMA
FROM sales
ORDER BY total_price ASC
LIMIT 5;

-- 10 uuemat müüki koos vajalike andmetega
SELECT customer_id, sale_date, total_price
FROM sales
ORDER BY sale_date DESC
LIMIT 10;

-- 3. FILTREERIMINE JA TINGIMUSED (WHERE, AND, OR, BETWEEN)

-- Suured müügid Tallinnas või Tartus
SELECT 
    'KOKKU RIDA:' AS sale_id, 
    COUNT(*) AS total_price, 
    NULL AS store_location
FROM sales
WHERE (store_location = 'Tallinn' OR store_location = 'Tartu') AND total_price > 100

UNION ALL

-- 2. TAVALISED ANDMEREAD
SELECT 
    sale_id::text, 
    total_price, 
    store_location
FROM sales
WHERE (store_location = 'Tallinn' OR store_location = 'Tartu') AND total_price > 100;

-- Väga suured või väga väikesed müügid
SELECT sale_id, total_price
FROM sales
WHERE total_price > 500 OR total_price < 10;

-- Vigased või puudulikud tehingud (summa <= 0 või klient puudub)
SELECT sale_id, customer_id, total_price, sale_date
FROM (
    -- 1. KOKKUVÕTTE RIDA (järjekord = 1)
    SELECT 
        1 AS jarjekord,
        'KOKKU TEHINGUID:' AS sale_id, 
        COUNT(*) AS customer_id, 
        NULL::numeric AS total_price, 
        NULL::date AS sale_date
    FROM sales
    WHERE total_price <= 0 OR customer_id IS NULL

    UNION ALL

    -- 2. TAVALISED ANDMEREAD (järjekord = 2)
    SELECT 
        2 AS jarjekord,
        sale_id::text, 
        customer_id, 
        total_price, 
        sale_date
    FROM sales
    WHERE total_price <= 0 OR customer_id IS NULL
) x
ORDER BY 
    jarjekord ASC,      -- Garanteerib, et kokkuvõte on ESimene (1 enne 2)
    total_price ASC;    -- Sorteerib andmeread omavahel summa järgi

-- Suured tellimused koos kokkuvõtliku tulemuste arvuga
SELECT sale_id, customer_id, total_price,
COUNT(*) OVER() AS kokku_tulemusi
FROM sales
WHERE total_price > 500
ORDER BY total_price DESC;

-- Kindla perioodi müügid (I kvartal 2024)
SELECT sale_id, sale_date, total_price,
COUNT(*) OVER() AS kokku_tulemusi
FROM sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY sale_date;

-- 4. KOKKUVÕTTE REA LISAMINE (UNION ALL)

-- Ilma kliendita müükide koond- ja detailvaade
SELECT 'KOKKU' AS sale_id, NULL AS customer_id, COUNT(*) AS total_price
FROM sales
WHERE customer_id IS NULL

UNION ALL

SELECT sale_id::text, customer_id, total_price
FROM sales
WHERE customer_id IS NULL;

-- Harjutus 2B: Tallinna 2024. a suured müügid (>200) koos kokkuvõttereaga
SELECT 
    'KOKKU' AS sale_id, 
    NULL AS customer_id, 
    COUNT(*) AS total_sales, 
    NULL AS sale_date
FROM sales
WHERE total_price > 200 
  AND sale_date BETWEEN '2024-01-01' AND '2024-12-31'
  AND store_location = 'Tallinn'

UNION ALL

SELECT 
    sale_id::text, 
    customer_id, 
    total_price, 
    sale_date
FROM sales
WHERE total_price > 200 
  AND sale_date BETWEEN '2024-01-01' AND '2024-12-31'
  AND store_location = 'Tallinn';


-- 5. UNIKAALSUS JA DUPLIKAATIDE KONTROLL (DISTINCT JA COUNT)

-- Unikaalsed kanalid tähestiku järjekorras
SELECT DISTINCT channel
FROM sales
ORDER BY channel;

-- Müügitabeli üldpilt (ridade arv, klientide olemasolu ja unikaalsus)
SELECT
    COUNT(*) AS ridade_arv,
    COUNT(customer_id) AS klientidega,
    COUNT(*) - COUNT(customer_id) AS puudub_klient,
    COUNT(DISTINCT customer_id) AS unikaalseid_kliente
FROM sales;

-- Müügi-duplikaatide kontroll ühe päringuga (asendab mitut UNION/üksikpäringut)
SELECT
    COUNT(*) AS kokku,
    COUNT(DISTINCT sale_id) AS unikaalseid,
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaatseid
FROM sales;

-- Kliendi e-mailide duplikaatide kontroll
SELECT
    COUNT(*) AS kokku,
    COUNT(DISTINCT email) AS unikaalseid_emaile,
    COUNT(*) - COUNT(DISTINCT email) AS duplikaatseid
FROM customers;

-- Tootetabeli (products) ülevaade
SELECT 
    COUNT(*) AS kokku,
    COUNT(DISTINCT category) AS unikaalseid_kategooriaid,
    COUNT(*) - COUNT(retail_price) AS puuduvad_hinnad
FROM products;

--milliseid kanaleid, asukohti ja makseviise on müügitabelis
SELECT channel, store_location, payment_method   
FROM sales    LIMIT 10;  

 -- Unikaalsed kaupluste asukohad
 SELECT DISTINCT store_location
 FROM sales;

--unikaalsed makseviisid
 SELECT DISTINCT payment_method
 FROM sales; 

 -- Online-müügid
 SELECT * FROM sales
 WHERE channel = 'online'
 ORDER BY total_price DESC
 LIMIT 15;

 -- Tehingud ilma kaupluse asukohata
 SELECT COUNT(*) AS puuduv_asukoht
 FROM sales
 WHERE store_location IS NULL;    

-- Tehingute arv kaupluse asukoha järgi (puuduvad asukohad on välja jäetud)
SELECT store_location, COUNT(*) AS tehinguid   
FROM sales   
WHERE store_location IS NOT NULL   
GROUP BY store_location
ORDER BY tehinguid DESC;

-- Online-tehingute arv
SELECT COUNT(*) AS online_tehinguid
FROM sales
WHERE channel = 'online'

UNION ALL

-- Poe-tehingute arv
SELECT COUNT(*) AS poe_tehinguid
FROM sales
WHERE channel = 'pood';

--Leia sularahamaksed Tartus:
SELECT * FROM sales
WHERE payment_method = 'sularaha'
AND store_location = 'Tartu'
ORDER BY total_price DESC
LIMIT 10;