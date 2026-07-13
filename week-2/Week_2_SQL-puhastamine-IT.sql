d-- Leia duplikaatsed sale_id väärtused
SELECT
    sale_id,
    COUNT(*) AS koopiate_arv
FROM sales
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

-- Anna igale reale number oma grupi sees
SELECT
    sale_id,
    customer_id,
    total_price,
    sale_date,
    ROW_NUMBER() OVER (PARTITION BY sale_id ORDER BY sale_date) AS rn
FROM sales;

-- Leia kõik duplikaatsed sale_id väärtused sales tabelis
SELECT
    sale_id,
    COUNT(*) AS koopiate_arv
FROM sales
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC
LIMIT 10;

-- Duplikaatide mõju müüginumbritele
SELECT
    COUNT(*) AS ridu_kokku,
    COUNT(DISTINCT sale_id) AS unikaalseid,
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate,
    SUM(total_price) AS summa_duplikaatidega,
    (SELECT SUM(total_price) FROM (
        SELECT DISTINCT ON (sale_id) total_price
        FROM sales
        ORDER BY sale_id, sale_date
    ) unikaalsed) AS summa_ilma_duplikaatideta
FROM sales;

1B:
Mitu emaili duplikaati on? sorteerides Cusotmer_ID järgi.
SELECT *
FROM (
    SELECT 
        customer_id, 
        email,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id ASC) AS rn
    FROM customers
) AS subquery
WHERE rn > 1;

SELECT 
    email, 
    COUNT(*) AS koopiate_arv
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

Leiame costumers tabelis duplikaate: 

SELECT
    phone, 
    COUNT(*) AS koopiate_arv
FROM customers
GROUP BY phone
HAVING COUNT(*) > 1
ORDER BY koopiate_arv ASC;

-- Leia tellimused, kus klient on teadmata
SELECT sale_id, customer_id, total_price
FROM sales
WHERE customer_id IS NULL;

-- Leia kliendid, kellel ON e-mail olemas
SELECT customer_id, first_name, email
FROM customers
WHERE email IS NOT NULL;

-- Asenda puuduv kliendi nimi vaikeväärtusega
SELECT
    customer_id,
    COALESCE(first_name, 'Tundmatu') AS eesnimi,
    COALESCE(email, 'puudub@urbanstyle.ee') AS email
FROM customers;

-- Mitu asendusväärtust (valib esimese mitte-NULL väärtuse)
SELECT COALESCE(NULL, NULL, 'Kolmas valik');
-- Tulemus: 'Kolmas valik'

-- NULLIF(a, b): kui a = b, tagastab NULL; muidu tagastab a
SELECT NULLIF(100, 100);  -- Tulemus: NULL
SELECT NULLIF(100, 200);  -- Tulemus: 100

-- Muuda 0-hinnaga tooted NULL-iks (hind pole tegelikult 0, vaid puudub)
SELECT
    product_id,
    product_name,
    NULLIF(retail_price, 0) AS puhas_hind
FROM products;

SELECT 100 + NULL;     -- Tulemus: NULL
SELECT NULL * 5;       -- Tulemus: NULL
SELECT SUM(total_price) FROM sales;  -- SUM ignoreerib NULL-e!

-- NULL-ide ülevaade customers tabelis
SELECT
    COUNT(*) AS kliente_kokku,
    COUNT(first_name) AS eesnimi_olemas,
    COUNT(*) - COUNT(first_name) AS eesnimi_puudub,
    COUNT(email) AS email_olemas,
    COUNT(*) - COUNT(email) AS email_puudub,
    COUNT(phone) AS telefon_olemas,
    COUNT(*) - COUNT(phone) AS telefon_puudub
FROM customers;


SELECT
    customer_id,
    COALESCE(first_name, 'Tundmatu klient') AS eesnimi,
    COALESCE(last_name, '') AS perekonnanimi,
    COALESCE(email, 'puudub@urbanstyle.ee') AS email,
    COALESCE(phone, 'Telefon puudub') AS telefon -- (või lihtsalt '', oleneb mis teksti soovid)
FROM customers

SELECT
    COUNT(*) AS ridu,
    COUNT(total_price) AS summa_olemas,
    COUNT(*) - COUNT(total_price) AS summa_puudub,
    SUM(total_price) AS kogusumma,
    AVG(total_price) AS keskmine
FROM sales;

-- CAST süntaks (standardne SQL)
SELECT CAST('125.50' AS NUMERIC);  -- Tekst -> number
SELECT CAST('2024-01-15' AS DATE); -- Tekst -> kuupäev

-- :: süntaks (PostgreSQL-i kiirviis)
SELECT '125.50'::NUMERIC;          -- Sama tulemus
SELECT '2024-01-15'::DATE;        -- Sama tulemus
-- Kuupäev erinevates formaatides
SELECT
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_formaat,
    TO_CHAR(sale_date, 'YYYY-MM-DD') AS iso_formaat,
    TO_CHAR(sale_date, 'DD. Month YYYY') AS pikk_formaat
FROM sales
LIMIT 5;

-- Leia kõik unikaalsed linnade kirjaviisid
SELECT DISTINCT city
FROM customers
ORDER BY city;

-- Ühtlusta: eemalda tühikud, muuda algustäht suureks
SELECT DISTINCT
    city AS originaal,
    TRIM(city) AS trimitud,
    UPPER(TRIM(city)) AS suurtahtedega,
    INITCAP(TRIM(city)) AS esitaht_suur
FROM customers
WHERE city IS NOT NULL
ORDER BY city;

-- Kuupäevade formateerimine UrbanStyle'i andmetes
SELECT
    sale_id,
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_kuupaev,
    TO_CHAR(sale_date, 'Day') AS nadalapäev,
    TO_CHAR(sale_date, 'YYYY-"Q"Q') AS kvartal,
    EXTRACT(DOW FROM sale_date) AS paev_nr
FROM sales
ORDER BY sale_date DESC
LIMIT 10;

-- Linnade ühtlustamise diagnostika
SELECT
    city AS originaal,
    TRIM(city) AS trimitud,
    INITCAP(TRIM(city)) AS puhastatud,
    COUNT(*) AS kliente
FROM customers
GROUP BY city
ORDER BY city;

Linnanimede puhastamine
SELECT
    INITCAP(TRIM(city)) AS puhastatud_linn,
    COUNT(customer_id) AS kliente_kokku,
    COUNT(DISTINCT city) AS erinevaid_kirjaviise
FROM customers
GROUP BY INITCAP(TRIM(city))
ORDER BY kliente_kokku DESC;

-- Kontrolli hinnaveeru tüüpi ja väärtusi
SELECT
    product_id,
    product_name,
    retail_price,
    CASE
        WHEN retail_price IS NULL THEN 'NULL'
        WHEN retail_price = 0 THEN 'NULL (0 = puudub?)'
        WHEN retail_price < 0 THEN 'NEGATIIVNE!'
        ELSE 'OK'
    END AS hinna_staatus
FROM products
WHERE retail_price IS NULL OR retail_price <= 0
ORDER BY retail_price;

-- Duplikaatide ülevaade kõigis tabelites
SELECT 'sales' AS tabel,
    COUNT(*) AS ridu_kokku,
    COUNT(DISTINCT sale_id) AS unikaalseid,
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate
FROM sales
UNION ALL
SELECT 'customers',
    COUNT(*),
    COUNT(DISTINCT email),
    COUNT(*) - COUNT(DISTINCT email)
FROM customers
UNION ALL
SELECT 'products',
    COUNT(*),
    COUNT(DISTINCT product_id),
    COUNT(*) - COUNT(DISTINCT product_id)
FROM products;

SELECT 
    'customers' AS tabel,
    'first_name' AS veerg,
    COUNT(*) - COUNT(first_name) AS puuduvaid_vaartusi
FROM customers
UNION ALL
SELECT 
    'customers' AS tabel,
    'email' AS veerg,
    COUNT(*) - COUNT(email) AS puuduvaid_vaartusi
FROM customers
UNION ALL
SELECT 
    'customers' AS tabel,
    'phone' AS veerg,
    COUNT(*) - COUNT(phone) AS puuduvaid_vaartusi
FROM customers
UNION ALL
-- UUS: Kliendi linn
SELECT 
    'customers' AS tabel,
    'city' AS veerg,
    COUNT(*) - COUNT(city) AS puuduvaid_vaartusi
FROM customers

UNION ALL

SELECT 
    'products' AS tabel,
    'category' AS veerg,
    COUNT(*) - COUNT(category) AS puuduvaid_vaartusi
FROM products
UNION ALL
SELECT 
    'products' AS tabel,
    'retail_price' AS veerg,
    COUNT(*) - COUNT(retail_price) AS puuduvaid_vaartusi
FROM products

UNION ALL

SELECT 
    'sales' AS tabel,
    'sale_id' AS veerg,
    COUNT(*) - COUNT(sale_id) AS puuduvaid_vaartusi
FROM sales
UNION ALL
-- UUS: Poe asukoht
SELECT 
    'sales' AS tabel,
    'store_location' AS veerg,
    COUNT(*) - COUNT(store_location) AS puuduvaid_vaartusi
FROM sales
UNION ALL
-- UUS: Müügikanal
SELECT 
    'sales' AS tabel,
    'channel' AS veerg,
    COUNT(*) - COUNT(channel) AS puuduvaid_vaartusi
FROM sales;


SELECT DISTINCT
    city AS algne_kirjaviis,
    INITCAP(TRIM(city)) AS puhastatud_kirjaviis
FROM customers
WHERE city IS NOT NULL
ORDER BY algne_kirjaviis;

create table sales_test AS
Select * 
from sales

Select * from sales_test limit 10;

 Delete from sales_test
 where sale_id = 2;

Select count (*) from sales_test;

SELECT invoice_id, count (*) AS koopiate_arv
FROM sales_test
 --WHERE invoice_id = 'INV-202301-00005'
Group by invoice_id
    having count (*) >1
    order by koopiate_arv desc
limit 10;