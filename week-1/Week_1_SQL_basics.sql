--Mitu toodet on tabelis
SELECT COUNT(*) FROM products;

--mitu kliendit on tabelis
Select COUNT (*) FROM customers;

--mitu müüki on tabelis
SELECT COUNT (*) FROM sales;

--koondtabel kõikide tabelite loendusest
SELECT 'products' AS tabel, COUNT(*) AS ridu FROM products
UNION ALL 
SELECT 'customers', COUNT(*) FROM customers
UNION ALL 
SELECT 'sales', COUNT(*) FROM sales;

--Näita ainult müügi kuupäeva, kliendi ID ja müügi koguhinda
SELECT customer_id, total_price, sale_date
FROM sales;

--Veergude ümbernimetamine
SELECT
    customer_id AS klient,
    total_price AS summa,
    sale_date AS kuupäev
FROM sales;

