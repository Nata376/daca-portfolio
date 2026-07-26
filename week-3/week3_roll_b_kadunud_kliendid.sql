-- LEFT JOIN: kõik kliendid, ka need kellel pole oste 
SELECT 
c.first_name, 
c.last_name,
c.email,
c.city,
c.registration_date,
s.sale_id 
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id 
WHERE s.sale_id IS NULL;    -- Kui sale_id on NULL, siis klient pole kunagi ostnud!

--Mitu klienti on kadunud?
SELECT 
COUNT(*) AS kadunud_kliente
FROM customers c 
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;    

--Kadunud kliendid linnade kaupa
SELECT 
    c.city, 
COUNT(*) AS kadunud_kliente
FROM customers c 
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL 
GROUP BY c.city 
ORDER BY kadunud_kliente DESC;

-- Millal kadunud kliendid registreerusid?
SELECT 
    c.first_name || ' ' || c.last_name AS klient, 
    c.registration_date,
    c.city,
    c.loyalty_tier
    FROM customers c 
    LEFT JOIN sales s ON c.customer_id = s.customer_id 
    WHERE s.sale_id IS NULL
    ORDER BY c.registration_date DESC;    

--kadunud vs aktiivsed kliendid
SELECT 
    CASE 
        WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'
        ELSE 'Aktiivne (on ostnud)'
    END AS staatus, 
    COUNT(DISTINCT c.customer_id) AS kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id 
GROUP BY 
    CASE 
        WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'
        ELSE 'Aktiivne (on ostnud)'
    END;

    --kadunud kliendid registreerimiskuu kaupa
SELECT 
    DATE_TRUNC('month', c.registration_date) AS registreerimis_kuu, 
    COUNT(*) AS kadunud_kliente 
FROM customers c 
LEFT JOIN sales s ON c.customer_id = s.customer_id 
WHERE s.sale_id IS NULL 
GROUP BY DATE_TRUNC('month', c.registration_date) 
ORDER BY kadunud_kliente DESC;
