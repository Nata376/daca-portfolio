-- Mitu klienti on kokku? 
SELECT COUNT(*) AS klientide_arv
FROM customers; 

-- Millised veerud ja andmed tabelis on?
SELECT * FROM customers
LIMIT 10; 

-- Millised linnad on esindatud?
SELECT DISTINCT city
FROM customers;

 -- Tallinna kliendid, sorteeritud nime järgi
 SELECT * FROM customers
 WHERE city = 'Tallinn'
 ORDER BY last_name ASC 
 LIMIT 15;   

  -- Vanim ja uusim registreerimine 
SELECT 
MIN(registration_date) AS vanim,
MAX(registration_date) AS uusim
FROM customers;

-- Mitu klienti, kus eesnimi on puudu? 
SELECT COUNT(*) - COUNT(first_name) AS puuduvad_eesnimed 
FROM customers;

-- Mitu klienti, kus e-mail on puudu?
 SELECT COUNT(*) - COUNT(email) AS puuduvad_emailid 
 FROM customers;    

--Duplikaatsed emailid
SELECT COUNT(*) AS kokku_emaile, 
COUNT(DISTINCT email) AS unikaalseid_emaile
FROM customers;   -- Vahe = duplikaadid!   `

--kliendid linniti
SELECT city, COUNT(*) AS klientide_arv
FROM customers
GROUP BY city 
ORDER BY klientide_arv DESC; 

--viimase 6 kuu registreerimised
SELECT * FROM customers
WHERE registration_date >= '2024-07-01'
ORDER BY registration_date DESC; 
