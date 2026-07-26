-- Millised müügikanalid on olemas?
SELECT DISTINCT 
    channel 
FROM sales 
ORDER BY channel;

-- Milline kanal toob enim müüke?
SELECT 
    s.channel AS müügikanal,
    COUNT(DISTINCT s.customer_id) AS kliente,
    COUNT(s.sale_id) AS oste,
    SUM(s.total_price) AS kogumüük
FROM sales s
GROUP BY s.channel
ORDER BY kogumüük DESC;

-- Millistest linnadest kliendid milliseid kanaleid kasutavad?
SELECT 
    s.channel AS müügikanal,
    c.city AS linn,
    COUNT(DISTINCT c.customer_id) AS kliente,
    SUM(s.total_price) AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY 
    s.channel, 
    c.city
ORDER BY 
    linn,
    kogumüük DESC;

-- 3 tabeli JOIN: millised tooted müüvad millises kanalis?
SELECT 
    s.channel AS müügikanal,
    p.category AS tootekategooria,
    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(s.sale_id) AS oste,
    SUM(s.total_price) AS kogumüük,
    ROUND(AVG(s.total_price), 2) AS keskmine_ost
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY 
    s.channel, 
    p.category
ORDER BY 
    müügikanal, 
    kogumüük DESC;

-- Müük kliendi kohta kanalite lõikes
SELECT 
    s.channel AS müügikanal,
    COUNT(DISTINCT s.customer_id) AS kliente,
    SUM(s.total_price) AS kogumüük,
    ROUND(SUM(s.total_price) / COUNT(DISTINCT s.customer_id), 2) AS müük_per_klient
FROM sales s
GROUP BY s.channel
ORDER BY müük_per_klient DESC;

-- Kaupluste ja müügikanalite tulemused
SELECT 
    s.store_location AS kauplus,
    s.channel AS müügikanal,
    COUNT(s.sale_id) AS oste,
    SUM(s.total_price) AS kogumüük,
    ROUND(SUM(s.total_price) / COUNT(s.sale_id), 2) AS keskmine_ost
FROM sales s
GROUP BY 
    s.store_location, 
    s.channel
ORDER BY 
    kauplus, 
    kogumüük DESC;
