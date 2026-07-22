
--MÜÜGIANDMETE PUHASTAMINE

SELECT COUNT(*) AS ridade_arv FROM sales_test;

--duplikaatsed tellimused
SELECT invoice_id, COUNT(*) AS koopiate_arv
FROM sales_test
GROUP BY invoice_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

--dplikaatsete ridade arvu leidmine
SELECT COUNT(*) AS duplikaat_read
FROM sales_test
WHERE id NOT IN ( --tõsta laualt ära ainult need, mis ei ole orignaalid
    SELECT MIN(id)
    FROM sales_test
    GROUP BY invoice_id
);
--Siin kontekstis SELect COUNT(*) jätab alles ainult need read, mis on duplikaadid ja kustutab originaalid.

--leia NULL väärtused kriitlistes väljades
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS null_total_price
FROM sales_test;

--Kontrollime kuupäevade formaati
SELECT COUNT(*) AS tuleviku_kuupaevad
FROM sales_test
WHERE sale_date > CURRENT_DATE;

-- Kustuta duplikaadid (jäta alles ainult esimene rida iga invoice_id kohta)
DELETE FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY invoice_id
);

-- Kontroll: ridade arv peaks nüüd olema unikaalsete invoice_id arv (~10 118)
SELECT COUNT(*) AS parast
FROM sales_test;

-- Vaata, kui palju külalisoste (client_ID NULL)
SELECT COUNT(*) AS külalisostud
FROM sales_test
WHERE customer_id IS NULL;

-- Client_ID NULL asendame "-1"
SELECT COALESCE(customer_id, -1)
AS customer_id_puhas
FROM sales_test;


-- Paranda tuleviku kuupäevad
UPDATE sales_test
SET sale_date = CURRENT_DATE
WHERE sale_date > CURRENT_DATE;

--kontrollime ridu
SELECT COUNT(*) AS ridu_parast FROM sales_test;

SELECT 
    COUNT(*) AS ridade_arv,
    SUM(total_price) AS kogusumma
FROM sales_test;

--KLIENDIANDMETE PUHASTAMINE

--Kontrollime ridade arbu
SELECT COUNT(*) AS ridade_arv FROM customers_test;

--duplikaatsed e-mailid:
SELECT email, COUNT(*) AS koopiate_arv
FROM customers_test
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

--puuduvad nimed
SELECT
    COUNT(*) FILTER (WHERE first_name IS NULL OR first_name = '') AS null_eesnimi,
    COUNT(*) FILTER (WHERE last_name IS NULL OR last_name = '') AS null_perenimi
FROM customers_test;

--Linnade kontroll
SELECT city, COUNT(*) AS arv
FROM customers_test
GROUP BY city
ORDER BY city;

--puuduvad tel ja e-mail
SELECT
    COUNT(*) FILTER (WHERE phone IS NULL OR phone = '') AS null_telefon,
    COUNT(*) FILTER (WHERE email IS NULL OR email = '') AS null_email
FROM customers_test;

-- Asenda NULL nimed
UPDATE customers_test
SET first_name = 'Tundmatu'
WHERE first_name IS NULL OR first_name = '';

-- Ühtlusta linnanimed INITCAP + TRIM abil
UPDATE customers_test
SET city = INITCAP(TRIM(city))
WHERE city != INITCAP(TRIM(city));

-- Standardiseeri e-mailid väiketähtedeks
UPDATE customers_test
SET email = LOWER(TRIM(email))
WHERE email != LOWER(TRIM(email));

-- Kontrolli tulemust
SELECT city, COUNT(*) AS arv
FROM customers_test
GROUP BY city ORDER BY city;

--standardiseeri telefoninumbrid
SELECT phone,
    CASE
        WHEN phone LIKE '+372%' THEN phone
        WHEN phone LIKE '372%' THEN '+' || phone
        WHEN LENGTH(phone) = 7 THEN '+372' || phone
        ELSE phone
    END AS standardne_telefon
FROM customers_test
WHERE phone IS NOT NULL
LIMIT 20;

--TOOTEANDMETE PUHASTAMINE
SELECT COUNT(*) AS ridade_arv FROM products_test;

--leiame duplikaadid
SELECT product_name, COUNT(*) AS koopiate_arv
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

--kriitilised 0 väärtused
SELECT
    COUNT(*) FILTER (WHERE product_name IS NULL OR product_name = '') AS null_nimi,
    COUNT(*) FILTER (WHERE category IS NULL OR category = '') AS null_kategooria,
    COUNT(*) FILTER (WHERE retail_price IS NULL) AS null_jaehind,
    COUNT(*) FILTER (WHERE cost_price IS NULL) AS null_omahind
FROM products_test;

-- Kas on negatiivseid hindu?
SELECT COUNT(*) AS negatiivne_hind
FROM products_test
WHERE retail_price < 0;

-- Kas on äärmuslikke hindu (> 1000€)?
SELECT product_name, retail_price
FROM products_test
WHERE retail_price > 1000
ORDER BY retail_price DESC;

--kategooriate järjekindus
SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category
ORDER BY category;

-- Ühtlusta kategooriate nimed
UPDATE products_test
SET category = INITCAP(TRIM(category))
WHERE category != INITCAP(TRIM(category));

-- Kontrolli tulemust
SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category ORDER BY category;

UPDATE products_test
SET category = CASE
    WHEN LOWER(TRIM(category)) IN ('shoes', 'jalanõud', 'footwear') THEN 'Shoes'
    WHEN LOWER(TRIM(category)) IN ('shirts', 'särgid', 'tops') THEN 'Shirts'
    WHEN LOWER(TRIM(category)) IN ('pants', 'püksid', 'trousers') THEN 'Pants'
    ELSE INITCAP(TRIM(category))
END;

--standartiseerime kategooriad
UPDATE products_test
SET category = CASE
    WHEN LOWER(TRIM(category)) IN ('shoes', 'jalanõud', 'footwear') THEN 'Shoes'
    WHEN LOWER(TRIM(category)) IN ('shirts', 'särgid', 'tops') THEN 'Shirts'
    WHEN LOWER(TRIM(category)) IN ('pants', 'püksid', 'trousers') THEN 'Pants'
    ELSE INITCAP(TRIM(category))
END;

--RISTVALIDEERIMINE JA KVALITEEDIKONTROLL

-- Orbid müügid — kas on customer_id, mida pole customers tabelis?
SELECT COUNT(*) AS orb_klient
FROM sales
WHERE customer_id IS NOT NULL
  AND customer_id NOT IN (SELECT customer_id FROM customers WHERE customer_id IS NOT NULL);

  -- Orbid müügid — kas on product_id, mida pole products tabelis?
SELECT COUNT(*) AS orb_toode
FROM sales
WHERE product_id IS NOT NULL
  AND product_id NOT IN (SELECT product_id FROM products WHERE product_id IS NOT NULL);

  --kes pole kunagi ostnud: 
  SELECT COUNT(*) AS vaimkliendid
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM sales WHERE customer_id IS NOT NULL);

--tooted mida pole kunagi müüdud
SELECT COUNT(*) AS vaimtooted
FROM products
WHERE product_id NOT IN (SELECT product_id FROM sales WHERE product_id IS NOT NULL);

--müügi ja tootehinna kontroll
SELECT 
    s.sale_id, 
    s.total_price, 
    p.retail_price AS tootehind, 
    s.quantity,
    s.total_price - (p.retail_price * s.quantity) AS erinevus
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE ABS(s.total_price - (p.retail_price * s.quantity)) > 1
ORDER BY ABS(s.total_price - (p.retail_price * s.quantity)) DESC;

-- Millistel tootel on suurimad hinnaerinevused?
SELECT 
    p.product_name, 
    p.category, 
    p.retail_price AS list_hind,
    AVG(s.total_price / NULLIF(s.quantity, 0)) AS kesk_muugihind,
    p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0)) AS erinevus
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.category, p.retail_price
HAVING ABS(p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0))) > 5
ORDER BY ABS(p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0))) DESC
LIMIT 10;