-- Leia duplikaatsed sale_id väärtused
SELECT --vali
    sale_id,
    COUNT(*) AS koopiate_arv --loenda mitu koopiat on
FROM sales 
GROUP BY sale_id --grupeeri sale_id järgi
HAVING COUNT(*) > 1 --vali ainult neid, kus on rohkem kui 1 koopia
ORDER BY koopiate_arv DESC;

-- Anna igale reale number oma grupi sees
SELECT
    sale_id,
    customer_id,
    total_price,
    sale_date,
    ROW_NUMBER() OVER (PARTITION BY sale_id ORDER BY sale_date) AS rn -- anna igale sale_id grupi reale number, järjestades kuupäeva järgi
FROM sales;


-- sales tabeli Duplikaatide mõju müüginumbritele
SELECT
    COUNT(*) AS ridu_kokku, --loeb ridu kokku
    COUNT(DISTINCT sale_id) AS unikaalseid, --loendab unikaalseid sale_id väärtusi
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate, --arvutab duplikaatide arvu
    SUM(total_price) AS summa_duplikaatidega, --arvutab summa koos duplikaatidega
    (SELECT SUM(total_price) FROM (-- Vali unikaalsed sale_id väärtused ja nende vastavad total_price väärtused
        SELECT DISTINCT ON (sale_id) total_price -- vali ainult unikaalsed sale_id väärtused ja nende vastavad total_price väärtused
        FROM sales
        ORDER BY sale_id, sale_date
    ) unikaalsed) AS summa_ilma_duplikaatideta
FROM sales;

--1B kliendid kellel on sama e-mail mitu korda 
SELECT * FROM (
    SELECT
        customer_id,
        first_name,
        last_name,
        email,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id) AS rn -- anna igale e-maili grupi reale number, järjestades customer_id järgi
    FROM customers
    WHERE email IS NOT NULL  -- Ainult üks WHERE alampäringu sees
) numbered                   -- Sulg sulgub ja saab nime "numbered"
WHERE rn > 1                 -- Väline WHERE filtreerib juba valmis 'rn' väärtust
ORDER BY email;

--kliendid kellel on sama telefoninumber mitu korda
SELECT * FROM (
    SELECT
        customer_id,
        first_name,
        last_name,
        phone,
        ROW_NUMBER() OVER (PARTITION BY phone ORDER BY first_name) AS rn -- anna igale phone grupi reale number, järjestades first_name järgi
    FROM customers
    WHERE phone IS NOT NULL
) numbered -- siin sulgub alampäring nimega 'numbered'
WHERE rn > 1     -- Väline WHERE filtreerib juba valmis 'rn' väärtust
ORDER BY phone;

--telefoninumbri duplikaatide loendamine
SELECT --vali
    phone,
    COUNT(*) AS koopiate_arv --loenda mitu koopiat on
FROM customers
GROUP BY phone --grupeeri phone järgi
HAVING COUNT(*) > 1 --vali ainult neid, kus on rohkem kui 1 koopia
ORDER BY koopiate_arv DESC;

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
    COALESCE(first_name, 'Tundmatu') AS eesnimi, --asendab puuduvad väärtused 'Tundmatu' stringiga
    COALESCE(email, 'puudub@urbanstyle.ee') AS email --asendab puuduvad väärtused 
FROM customers;

-- Muuda 0-hinnaga tooted NULL-iks (hind pole tegelikult 0, vaid puudub)
SELECT
    product_id,
    product_name,
    NULLIF(retail_price, 0) AS puhas_hind
FROM products;

--2A  leia UrbanStyle'i andmetest NULL väärtused.
-- NULL-ide ülevaade customers tabelis
SELECT
    COUNT(*) AS kliente_kokku, -- loe kõik kliendid kokku
    COUNT(first_name) AS eesnimi_olemas, -- loe kliendid, kellel on eesnimi olemas
    COUNT(*) - COUNT(first_name) AS eesnimi_puudub, -- loe kliendid, kellel ei ole eesnime
    COUNT(email) AS email_olemas, -- loe kliendid, kellel on email olemas
    COUNT(*) - COUNT(email) AS email_puudub, -- loe kliendid, kellel ei ole emaili
    COUNT(phone) AS telefon_olemas, -- loe kliendid, kellel on telefoninumber olemas
    COUNT(*) - COUNT(phone) AS telefon_puudub -- loe kliendid, kellel ei ole telefoninumber
FROM customers;

-- Kliendid, kellel puudub nimi VÕI e-mail
SELECT customer_id, first_name, last_name, email, city
FROM customers
WHERE first_name IS NULL
   OR last_name IS NULL
   OR email IS NULL
ORDER BY customer_id
LIMIT 15;

--Ilma nimeta kliendid muudame "tundmatu"
SELECT
    customer_id,
    COALESCE(first_name, 'Tundmatu') AS eesnimi, --asendab puuduvad väärtused 'Tundmatu' stringiga
    COALESCE(last_name, 'Tundmatu') AS perekonnanimi, --asendab puuduvad väärtused 'Tundmatu' stringiga
    COALESCE(email, 'puudub@urbanstyle.ee') AS email, --asendab puuduvad väärtused 'puudub@urbanstyle.ee' stringiga
    COALESCE(phone, 'puudub') AS telefoninumber --asendab puuduvad väärtused 'puudub' stringiga
FROM customers;

-- Võrdlus: SUM kõigist vs SUM mitte-NULL väärtustest
SELECT
    COUNT(*) AS ridu,
    COUNT(total_price) AS summa_olemas,
    COUNT(*) - COUNT(total_price) AS summa_puudub,
    SUM(total_price) AS kogusumma,
    AVG(total_price) AS keskmine
FROM sales;


-- Kuupäev erinevates formaatides
SELECT
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_formaat,
    TO_CHAR(sale_date, 'YYYY-MM-DD') AS iso_formaat,
    TO_CHAR(sale_date, 'DD. Month YYYY') AS pikk_formaat
FROM sales
LIMIT 5;

-- Tekst -> kuupäev (pead ütlema, millises formaadis tekst on)
SELECT TO_DATE('15/03/2024', 'DD/MM/YYYY')  -- Tulemus: 2024-03-15

union all 

SELECT TO_DATE('2024-01-15', 'YYYY-MM-DD');  -- Tulemus: 2024-01-15


-- Leia kõik unikaalsed linnade kirjaviisid
SELECT DISTINCT city
FROM customers
ORDER BY city;

-- Ühtlusta: eemalda tühikud, muuda algustäht suureks
SELECT DISTINCT
    city AS originaal,
    TRIM(city) AS trimitud,--eemalda tühikud algusest ja lõpust
    UPPER(TRIM(city)) AS suurtahtedega, --muuda kõik tähed suurteks
    INITCAP(TRIM(city)) AS esitaht_suur --muuda iga sõna esimene täht suureks
FROM customers
WHERE city IS NOT NULL
ORDER BY city;

--3a 
-- Kuupäevade formateerimine UrbanStyle'i andmetes
SELECT
    sale_id,
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_kuupaev,
    TO_CHAR(sale_date, 'Day') AS nadalapäev,
    TO_CHAR(sale_date, 'YYYY-"Q"Q') AS kvartal,
    EXTRACT(DOW FROM sale_date) AS paev_nr -- 0 = pühapäev, 1 = esmaspäev, ..., 6 = laupäev
FROM sales
ORDER BY sale_date DESC
LIMIT 10;

-- Linnade ühtlustamise diagnostika
SELECT
    city AS originaal,
    TRIM(city) AS trimitud, --eemalda tühikud
    INITCAP(TRIM(city)) AS puhastatud, --muuda iga sõna esimene täht suureks
    COUNT(*) AS kliente -- loenda mitu klienti on igas linnas
FROM customers
GROUP BY city
ORDER BY city;

-- Linnade ühtlustamise diagnostika
SELECT
    INITCAP(TRIM(city)) AS puhastatud_linn, --muuda iga sõna esimene täht suureks
    COUNT(*) AS kliente_kokku, -- loenda mitu klienti on igas linnas
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

--TERVIKLIK PUHASTAMISRAPORT: 
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

--Iga tabeli NULL väärtuste ülevaade
SELECT 'sales' AS tabel,
    COUNT(*) AS ridu_kokku,
    COUNT(sale_id) AS sale_id_olemas,
    COUNT(*) - COUNT(sale_id) AS sale_id_puudub,
    COUNT(customer_id) AS customer_id_olemas,
    COUNT(*) - COUNT(customer_id) AS customer_id_puudub,
    COUNT(total_price) AS total_price_olemas,
    COUNT(*) - COUNT(total_price) AS total_price_puudub,
    COUNT(sale_date) AS sale_date_olemas,
    COUNT(*) - COUNT(sale_date) AS sale_date_puudub
FROM sales;


-- Formaatide diagnostika linna nimedes
SELECT
    INITCAP(TRIM(city)) AS puhas_linn, --muuda iga sõna esimene täht suureks
    COUNT(*) AS kliente,               -- loenda mitu klienti on igas linnas
    COUNT(DISTINCT city) AS erinevaid_kirjaviise, -- loenda mitu erinevat kirjaviisi on
    STRING_AGG(DISTINCT city, ', ' ORDER BY city) AS algkirjaviisid -- loenda kõik erinevad kirjaviisid ühte lahtrisse, eraldades need komaga
FROM customers
WHERE city IS NOT NULL
GROUP BY INITCAP(TRIM(city))
ORDER BY kliente DESC;

SELECT
    INITCAP(TRIM(city)) AS linn, --muuda iga sõna esimene täht suureks
    COUNT(*) AS kliente_kokku,       -- loenda mitu klienti on igas linnas
    COUNT(*) - COUNT(email) AS email_puudub, -- loenda mitu klienti pole emaili
    ROUND(
        100.0 * (COUNT(*) - COUNT(email)) / COUNT(*), 1 -- arvuta protsent, mitu klienti pole emaili, ümardades ühe kümnendkohani
    ) AS puudub_protsent
FROM customers
GROUP BY INITCAP(TRIM(city))
ORDER BY kliente_kokku DESC;