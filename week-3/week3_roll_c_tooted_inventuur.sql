------ INVENTORY -------

-- Laoseis tooted linnade kaupa
SELECT 
    i.product_id,
    p.product_name, -- või veeru nimi sinu products tabelis (nt 'name' või 'title')
    i.location AS linn,
    SUM(i.quantity_available) AS kogus_linnas,
    i.reorder_point
FROM inventory i
JOIN products p ON i.product_id = p.product_id
GROUP BY 
    i.product_id, 
    p.product_name,
    i.location,
    i.reorder_point
ORDER BY 
    i.product_id, 
    i.location;

-- Tooteid kokku asukoha põhiselt
SELECT 
    location AS linn,
    SUM(quantity_available) AS kokku_tooteid_laos,
    COUNT(DISTINCT product_id) AS erinevaid_tooteid
FROM inventory
GROUP BY location
ORDER BY kokku_tooteid_laos DESC;

--enim müüdud tooted
SELECT 
    p.product_name,
    p.category,
    p.subcategory,
    COUNT(s.sale_id) AS müüdud_kordi,
    SUM(s.total_price) AS kogumüük
FROM products p
INNER JOIN sales s ON p.product_id = s.product_id
GROUP BY 
    p.product_id, 
    p.product_name, 
    p.category, 
    p.subcategory
ORDER BY kogumüük DESC
LIMIT 10;

--müük kategooriate kaupa
SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) AS tooteid,
    COUNT(s.sale_id) AS müüke,
    SUM(s.total_price) AS kogumüük
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY kogumüük DESC;

--millised tooted on laos
SELECT 
    p.product_name,
    p.category,
    i.location,
    i.quantity_available,
    i.reorder_point,
    CASE 
        WHEN i.quantity_available <= i.reorder_point THEN 'TELLI JUURDE'
        ELSE 'OK'
    END AS staatus
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id
ORDER BY i.quantity_available ASC;

--tooted, mis on laos, aga pole kunagi müüdud — topelt kahju (laoseis + müümata):
SELECT 
    p.product_name,
    p.category,
    p.retail_price,
    i.quantity_available,
    (p.retail_price * i.quantity_available) AS kinni_olev_raha
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE s.sale_id IS NULL 
  AND i.quantity_available > 0
ORDER BY kinni_olev_raha DESC;