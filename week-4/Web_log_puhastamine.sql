-- 1. Loome tabelist web_logs koopia nimega web_logs_test koos kõigi andmetega
CREATE TABLE web_logs_test AS 
SELECT * FROM web_logs;

-- 2. Kontrollime, et andmed jõudsid uude tabelisse kohale
SELECT * FROM web_logs_test LIMIT 10;

UPDATE web_logs_test
SET source = CASE 
    -- 1. Google Organic (orgaaniline otsing)
    WHEN LOWER(TRIM(source)) IN ('google_organic', 'google organic', 'google') THEN 'Google Organic'
    
    -- 2. Google Ads (tasuline reklaam)
    WHEN LOWER(TRIM(source)) IN ('google_ads', 'google ads', 'google_cpc', 'google/cpc') THEN 'Google Ads'
    
    -- 3. Facebook Ads (tasuline reklaam)
    WHEN LOWER(TRIM(source)) IN ('facebook_ads', 'facebook ads', 'fb_ads', 'fb ads', 'fb_ad') THEN 'Facebook Ads'
    
    -- 4. Facebook Organic (tasuta lehe külastus)
    WHEN LOWER(TRIM(source)) IN ('facebook', 'fb', 'facebook_organic') THEN 'Facebook Organic'
    
    -- 5. Instagram Ads & Organic
    WHEN LOWER(TRIM(source)) IN ('instagram_ads', 'instagram ads', 'ig_ads') THEN 'Instagram Ads'
    WHEN LOWER(TRIM(source)) IN ('instagram', 'ig', 'instagram_organic') THEN 'Instagram Organic'
    
    -- 6. Email kampaaniad
    WHEN LOWER(TRIM(source)) LIKE '%email%' THEN 'Email Campaign'
    
    -- 7. Direct / Otse
    WHEN LOWER(TRIM(source)) = 'direct' THEN 'Direct'
    
    -- 8. Puuduvad väärtused
    WHEN source IS NULL THEN 'Teadmata / Otse'
    
    -- Kõik muud võimalikkused vormindatakse ilusa algustähega
    ELSE INITCAP(TRIM(source))
END;

SELECT 
    source, 
    COUNT(*) AS ridade_arv 
FROM web_logs_test 
GROUP BY source 
ORDER BY ridade_arv DESC;

SELECT 
    (SELECT COUNT(DISTINCT source) FROM web_logs) AS algne_allikate_arv,
    (SELECT COUNT(DISTINCT source) FROM web_logs_test) AS puhastatud_allikate_arv;

    SELECT COUNT(DISTINCT source) AS erinevaid_kirjaviise_kokku
FROM web_logs;

UPDATE web_logs_test
SET source = CASE 
    WHEN LOWER(TRIM(source)) IN ('google_organic', 'google organic', 'google') THEN 'Google Organic'
    WHEN LOWER(TRIM(source)) IN ('google_ads', 'google ads', 'google_cpc', 'google/cpc') THEN 'Google Ads'
    WHEN LOWER(TRIM(source)) IN ('facebook_ads', 'facebook ads', 'fb_ads', 'fb ads', 'fb_ad') THEN 'Facebook Ads'
    WHEN LOWER(TRIM(source)) IN ('facebook', 'fb', 'facebook_organic') THEN 'Facebook Organic'
    WHEN LOWER(TRIM(source)) IN ('instagram_ads', 'instagram ads', 'ig_ads') THEN 'Instagram Ads'
    WHEN LOWER(TRIM(source)) IN ('instagram', 'ig', 'instagram_organic') THEN 'Instagram Organic'
    WHEN LOWER(TRIM(source)) LIKE '%email%' THEN 'Email Campaign'
    WHEN LOWER(TRIM(source)) = 'direct' THEN 'Direct'
    ELSE INITCAP(TRIM(source))
END;

SELECT 
    source AS puhas_source, 
    COUNT(*) AS ridu_kokku 
FROM web_logs_test 
GROUP BY source 
ORDER BY ridu_kokku DESC;

SELECT 
    (SELECT COUNT(*) FROM web_logs) AS originaal_ridu,
    (SELECT COUNT(*) FROM web_logs_test) AS test_ridu,
    CASE 
        WHEN (SELECT COUNT(*) FROM web_logs) = (SELECT COUNT(*) FROM web_logs_test) 
        THEN 'JAH (arvud klapivad!)' 
        ELSE 'EI (read ei klapi!)' 
    END AS kas_arvud_klapivad;

    UPDATE web_logs
SET source = CASE 
    WHEN LOWER(TRIM(source)) IN ('google_organic', 'google organic', 'google') THEN 'Google Organic'
    WHEN LOWER(TRIM(source)) IN ('google_ads', 'google ads', 'google_cpc', 'google/cpc') THEN 'Google Ads'
    WHEN LOWER(TRIM(source)) IN ('facebook_ads', 'facebook ads', 'fb_ads', 'fb ads', 'fb_ad') THEN 'Facebook Ads'
    WHEN LOWER(TRIM(source)) IN ('facebook', 'fb', 'facebook_organic') THEN 'Facebook Organic'
    WHEN LOWER(TRIM(source)) IN ('instagram_ads', 'instagram ads', 'ig_ads') THEN 'Instagram Ads'
    WHEN LOWER(TRIM(source)) IN ('instagram', 'ig', 'instagram_organic') THEN 'Instagram Organic'
    WHEN LOWER(TRIM(source)) LIKE '%email%' THEN 'Email Campaign'
    WHEN LOWER(TRIM(source)) = 'direct' THEN 'Direct'
    ELSE INITCAP(TRIM(source))
END;

SELECT 
    source AS puhas_source, 
    COUNT(*) AS ridu_kokku 
FROM web_logs
GROUP BY source 
ORDER BY ridu_kokku DESC;