--1A INNER JOIN: kliendid koos nende müükidega
SELECT
    c.first_name,
    c.last_name,
    c.city,
    s.sale_id,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.total_price DESC;

--1B Tootenimed koos müüdud kogustega.
SELECT
   p.product_name AS toode,
   p.category AS kategooria,
   s.quantity AS kogus,
   s.unit_price AS ühikuhind
FROM products p
INNER JOIN sales s ON s.product_id = p.product_id
ORDER BY s.quantity DESC
LIMIT 15;

--1C Kuidas sooritavad oste erinevate linnade kliendid?
SELECT
 s.channel AS müügikanal,
 c.first_name AS eesnimi,
 c.last_name AS Perekonnanimi,
 c.city AS päritolu
 FROM customers c
INNER JOIN sales s ON s.customer_id = c.customer_id
ORDER BY c.city ASC
LIMIT 10;

--2A Kadunud kliendid
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

-- 2A Kadunud kliendid koos linna koguarvuga
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nimi,
    c.email,
    c.city,
    c.registration_date,
    COUNT(*) OVER (PARTITION BY c.city) AS kadunud_kliente_linnas
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
ORDER BY c.city ASC, c.registration_date ASC;

-- Võrdluseks: INNER JOIN (ainult aktiivsed kliendid)
SELECT COUNT(DISTINCT c.customer_id) AS aktiivseid_kliente
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id;

--2B tooted ilma müügita
SELECT
    p.product_name AS tootenimi,
    p.category AS kategooria,
    p.retail_price AS hind
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;

--2C Kadunud klientide analüüs
SELECT
    c.city AS linn,
    COUNT(c.customer_id) AS kadunud_kliente_linnas
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY c.city
ORDER BY kadunud_kliente_linnas DESC;
    
--3A Kes ostis mida?
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

--3B Millised tootekategooriad müüvad igas linnas kõige rohkem?
SELECT
    p.category AS kategooria,
    c.city AS linn,
    COUNT(s.sale_id) AS müüke,
    SUM(s.total_price) AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY c.city, p.category
ORDER BY kogumüük DESC;

--3C Millised tellimused sisaldavad enim erinevaid tooteid?
SELECT 
    s.invoice_id AS "Arve nr",
    s.quantity AS "toodete kogus",
    c.first_name || ' ' || c.last_name AS "Nimi",
    c.city AS "Linn",
    SUM(s.total_price) AS "Summa"
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
RIGHT JOIN products p ON s.product_id = p.product_id
GROUP BY s.invoice_id, s.quantity, c.first_name, c.last_name, c.city
ORDER BY "toodete kogus" DESC, "Nimi" ASC;

--Integreeriv harjutus:
--TOP 20 klienti koos tootekategooriatega
SELECT
    c.first_name || ' ' || c.last_name AS "Nimi",
    c.city AS "Linn",
    p.category AS "Kategooria",
    SUM(s.total_price) AS "Kogumüük"
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY 
    c.first_name,
    c.last_name,
    c.city,
    p.category
ORDER BY "Kogumüük" DESC
LIMIT 20;


--päring 2 = 2A

--päring 3 Müümata tooted kategooriate kaupa
SELECT
    p.category AS "Kategooria",
    p.product_name AS "Toode"
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
ORDER BY p.category ASC, p.product_name ASC;


--kadunud kliendid linnade kaupa:

SELECT
   c.customer_id,
   c.first_name || ' ' || c.last_name AS nimi,
   c.email,
   c.city,
   c.registration_date,
   COUNT(*) OVER (PARTITION BY c.city) AS kadunud_kliente_linnas
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
ORDER BY c.city ASC, c.registration_date ASC;
