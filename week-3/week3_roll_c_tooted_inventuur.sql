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