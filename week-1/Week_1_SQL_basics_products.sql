-- Mitu toodet on kokku?
SELECT COUNT(*) AS toodete_arv
FROM products; 

-- Millised veerud ja andmed tabelis on? 
SELECT * FROM products
LIMIT 10; 

-- Kõik unikaalsed tootekategooriad
SELECT DISTINCT category
FROM products; 

-- 10 kallemat toodet
SELECT product_name, category, retail_price 
FROM products
ORDER BY retail_price DESC 
LIMIT 10;

 -- 10 odavamat toodet
SELECT product_name, category, retail_price
FROM products 
ORDER BY retail_price ASC
LIMIT 10;    

-- Näite: kõik kindla kategooria tooted
SELECT * FROM products 
WHERE category = 'jalanõusid'
ORDER BY retail_price DESC;

-- Puuduvad hinnad 
SELECT COUNT(*) - COUNT(retail_price) AS puuduvad_hinnad
FROM products;

-- Tooted kategooriati kokku:
SELECT category, COUNT(*) AS toodete_arv
FROM products
GROUP BY category
ORDER BY toodete_arv DESC;   

--Leia keskmised hinnad kategooriati:
SELECT category, 
COUNT(*) AS toodete_arv,
MIN(retail_price) AS min_hind,
MAX(retail_price) AS max_hind
FROM products
GROUP BY category
ORDER BY max_hind DESC;   

-- Tooted, mille hind on üle 50 EUR konkreetses kategoorias:
SELECT * FROM products
WHERE retail_price > 50 AND category = 'jalanõusid'
ORDER BY retail_price DESC;  