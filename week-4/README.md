# 🔗 Nädal 4: SQL Aggregations & Advanced Analytics — CEO ja Juhatuse Raport

## 📌 Lähteülesanne
> **Kristi Tamm (CEO):** *"Ma ei vaja pelgalt SQL-päringuid — ma tahan selgeid ärivastuseid juhatuse koosolekuks! Kuidas muutub meie käive kuude kaupa, kes on meie võtmekliendid, millised linnad toovad lõviosa tulust ja kus on laoseisudes käärid?"*
> 
> **Lahendus:** Kasutasime keerukaid grupeerimisi (`GROUP BY`, `HAVING`), ajutisi vahetabeleid (`CTE`) ja aknafunktsioone (`LAG()`, `ROW_NUMBER()`, `RANK()`, `OVER (PARTITION BY)`), et koondada andmed tegevjuhi ja juhatuse jaoks strateegilisteks vastusteks. Lisatsüklina korrigeerisime veebilogide ja müükide liitmise loogikat: ühtlustasime `web_logs` tabeli algsed 19 ebaühtlast allikanime selgeteks põhikanaliteks ning eemaldasime dubleerimise, et kajastada täpset tegelikku kogukäivet (~2,91 mln €).

---

## 📊 Analüüsi Tulemused ja Ärivastused Juhatusele

### 1. CEO Raport: Regionaalne Top 5 ja Igakuine Trend
* **Päring:** Ehitasime kaheastmelise CTE-päringu (`linna_myyk` ja `linna_jarjestus`), kus filtreerisime välja väikesed piirkonnad (`HAVING COUNT > 5`), arvutasime linna osakaalu kogu käibest aknafunktsiooniga `SUM() OVER ()` ning võrdlesime detsembri käivet eelmiste kuude keskmisega ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Kvartali%20tulemused.png)).
* **Tulemus ja regionaalne jaotus:**
  1. **Tallinn:** 1800 tellimust | **499 652,62 €** | **37,8% kogu käibest** (Detsember: 56,5k € vs keskmine 40,3k €)
  2. **Tartu:** 908 tellimust | **262 593,48 €** | **19,9% kogu käibest** (Detsember: 29,8k € vs keskmine 21,2k €)
  3. **Pärnu:** 644 tellimust | **196 675,23 €** | **14,9% kogu käibest** (Detsember: 24,6k € vs keskmine 15,6k €)
  4. **Narva:** 204 tellimust | **60 026,30 €** | **4,5% kogu käibest**
  5. **Viljandi:** 193 tellimust | **51 761,90 €** | **3,9% kogu käibest**
* **💡 Olulisemad järeldused Kristile:**
  * **Kõrge kontsentratsioonitase:** TOP 3 linna (Tallinn, Tartu, Pärnu) toovad kokku **72,6% kogu ettevõtte käibest** (Tallinn üksi annab ligi 38%) ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/M%C3%BC%C3%BCk%20linnade%20l%C3%B5ikes.png)).
  * **Erinevus #1 ja #5 vahel:** Tallinna käive ületab Viljandi käivet ligi **9,6-kordselt** (vahe on **447 890,72 €**).
  * **Aasta lõpu müügisööst:** Kõigis TOP 5 linnades ületas detsembri käive märgatavalt aasta varasemate kuude keskmist, näidates tugevat pühadehooaega.

---

### 2. Kliendianalüüs ja Segmentatsioon
* **Päring:** Grupeerisime kliendid nende kogukäibe alusel segmentidesse: `VIP` (> 3000 €), `Aktiivne` (1001–3000 €), `Tavaline` (1–1000 €) ja `Ostuta / Inaktiivne` (0 €) ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Segmenteeritud%20kliendid%20.png)).
* **Tulemus:**
  * **3150 kliendist** jagunesid tegelikud ostjad järgmiselt ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Klient%2Bm%C3%BC%C3%BCk%20%C3%BCle%20500%E2%82%AC.png)):
    * **VIP:** 44 klienti (keskmine käive **9 916,35 €**)
    * **Aktiivne:** 892 klienti (keskmine käive **1 559,80 €**)
    * **Tavaline:** 1615 klienti (keskmine käive **492,30 €**)
    * **Ostuta / Inaktiivne:** 599 klienti (käive **0 €**)
* **Otsus Kristile:** Eraldi tähelepanu vajavad 44 VIP-klienti, kes toovad ebasuproportsionaalselt suure osa käibest, ning 599 registreerunud kasutajat, kes vajavad esimese ostu stiimulit.

#### 💡 Soovitused ABC / Segmentatsioonianalüüsi Põhjal
* **A-Klass (VIP): Maksimaalne tähelepanu ja käsitöö**  
  Kuna piiratud arv VIP-kliente toob kriitilise osa käibest, peab nende hoidmine olema personaalne. Neile ei saadeta tavalisi mass-uudiskirju, vaid luuakse personaalsed pakkumised ja eksklusiivne lojaalsusprogramm.
* **B-Klass (Aktiivsed kliendid): Ristmüük ja stimuleerimine**  
  See grupp moodustab tugeva vundamendi. Siin tasub analüüsida ostukorvi sisu ning rakendada lisamüüki (cross-sell / up-sell), et tõsta nende ostusagedust ja kasvatada neid VIP-segmenti.
* **C-Klass (Tavalised & Inaktiivsed): Automatiseerimine**  
  Tavalisi ja seni ostuta kasutajaid on kokku üle 2200. Nende haldamine käsitsi nõuaks liiga palju ressurssi. Tegevus peab olema 100% automatiseeritud: automaatsed tervitus-e-mailid, esimese ostu sooduskupongid ja uuesti kaasamise kampaaniad tegevuskulude madalal hoidmiseks.

---

### 3. Igakuine Käibe Kasv ja Dünamika (`LAG()` Window Function)
* **Päring:** Kasutasime `DATE_TRUNC('month', sale_date)` ja aknafunktsiooni `LAG()`, et arvutada igakuine käibekasv nii absoluutnumbris kui protsentides ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/CTE%20Kuu%20k%C3%A4ive%20ja%20kasv.png)).
* **Müükide analüüs kuude ja nädalapäevade kaupa:**
  * **Q1 müügid:** Analüüsitud eraldi 2024. aasta I kvartali dünaamikat ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/2024%20Q1%20%20m%C3%BC%C3%BCgidkuude%20kaupa.png)).
  * **Aasta koondvaade:** Terve 2024. aasta müügid kuude lõikes ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/M%C3%BC%C3%BCk%20kuude%20l%C3%B5ikes%202024.png)).
  * **Nädalamuster:** Tuvastatud müügimahud nädalapäevade kaupa ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/M%C3%BC%C3%BCk%20n%C3%A4dalap%C3%A4evade%20kaupa.png)).
* **Märkus andmekvaliteedi kohta:**
  * Kui kliendi lõikes puudus eelneva kuu ost, tagastas `LAG()` algselt `NULL`-i.
  * Lahendasime selle `COALESCE(..., 0)` funktsiooniga ning täiendasime protsendiarvutust `CASE WHEN` loogikaga, vältimaks matemaatilist 0-ga jagamise viga.

---

### 4. Inventuuristatistika ja Tooted
* **Päring:** Liitsime `products` ja `sales` tabelid ning filtreerisime mahud `HAVING SUM(s.quantity) > 100` abil. Aknafunktsiooniga `ROW_NUMBER() OVER (PARTITION BY category ORDER BY retail_price DESC)` eraldasime iga kategooria hinna- ja müügitipud ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Kategooria%20m%C3%BC%C3%BCgid%20%C3%BCle%20500.png)).
* **Tulemused kategooriate lõikes:**
  * **Jalanõud:** Ettevõtte peamine käibeallikas — **774 034,75 €** (3737 tk, 71 erinevat toodet).
  * **Meeste riided:** Suurim füüsiline müügikogus — **4121 tk** (käive **749 798,72 €**, 81 toodet).
  * **Naiste riided:** Tugev positsioon käibes — **686 464,24 €** (3604 tk, 68 toodet).
  * **Laste riided & Aksessuaarid:** Suur ühikute müük (laste riided 3686 tk, aksessuaarid 3231 tk), kuid madala ühikuhinna tõttu väiksem käibepanus (305k € ja 393k €).
* **TOP 3 toodet kategooriates (`PARTITION BY` vajalikkus):**
  * Ilma partitsioonita tagastaks päring vaid poodide üldised kallimad tooted. `PARTITION BY p.category` taaskäivitas loenduri iga kategooria jaoks, tuues välja igast tootegrupist eraldi kolm peamist mudelit ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/kategooria%20TOP%203%20toodet.png)).

---

### 5. Turunduskampaaniate ROI ja Kanali Efektiivsus
* **Andmekvaliteedi puhastamine ja kanalinimede ühtlustamine:**
  * **Algne probleem:** Tabelis `web_logs` esines tervelt **19 erinevat allikakujutakuju ja variatsiooni** (nt tõstutundlikud erinevused, trükivead, eri sildid nagu `Google Organic`, `google_organic`, `FB Ads`, `Facebook_Ads` jne).
  * **Lahendus:** Ühtlustasime `CASE WHEN` ja `LOWER()` loogikaga kõik variatsioonid ühesteks põhikanaliteks ([📜 Puhastuskood GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Web_log_puhastamine.sql)).
  * **Dubleerimise vältimine:** Algne otseliitmine tekitas dubleerimise, korrutades tegeliku käibe mitmekordseks. Kasutasime vahetabelit (`WITH kliendi_kanal AS (SELECT DISTINCT ON (customer_id) ... ORDER BY customer_id, visit_date DESC)`), mis omistas igale kliendile tema viimase puhastatud turunduskanali. See tagas, et iga tehing arvestatakse täpselt ühes kanalis ja kogusumma klapib tegeliku käibega (**2 908 177,98 €**).

* **Korrigeeritud ja täpsed tulemused juhtkonnale (Päringu tulemuste alusel):**
  1. **Google Organic:** Peamine kasvumootor — **706 400,94 €** (730 ostnud klienti / 868 üldiselt | 2415 tellimust) ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Turunduskampiaanad%20koondvaade.png)).
  2. **Facebook Ads:** Tugevaim makstud reklaamikanal — **459 334,38 €** (361 ostnud klienti / 409 üldiselt | 1607 tellimust) ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Kanalite%20effektiivsus..png)).
  3. **Direct (Otseostud):** Püsikliendid — **421 776,57 €** (467 ostnud klienti / 541 üldiselt | 1514 tellimust).
  4. **Teadmata / Otse (NULL):** Veebilogides tuvastamata allikas — **383 127,19 €** (90 ostnud klienti | 1338 tellimust).
  5. **Email Campaign:** Kõrge tasuvusega korduvostud — **300 296,85 €** (275 ostnud klienti / 320 üldiselt | 1024 tellimust).
  6. **Instagram Organic:** **263 030,64 €** (263 ostnud klienti / 319 üldiselt | 879 tellimust).
  7. **Google Ads:** **185 115,44 €** (195 ostnud klienti / 221 üldiselt | 662 tellimust).
  8. **TikTok:** **128 252,56 €** (128 ostnud klienti / 160 üldiselt | 465 tellimust).
  9. **Facebook Organic & Instagram Ads:** Väiksema osakaaluga kanalid — vastavalt **43 395,97 €** (145 tellimust) ja **18 447,44 €** (69 tellimust).

* **💡 Oluline järeldus ja ajaline dünaamika:**
  * Aknafunktsiooniga `LAG(kogukäive) OVER (PARTITION BY turunduskanal ORDER BY kuu)` jälgitud kuine dünaamika kinnitab stabiilset igakuist müügivoolu peamistes kanalites läbi terve aasta ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Kuised%20trendid..png)).

---

## 🔗 SQL Päringud ja Hoidla Lingid

* 📁 **Minu kaust tiimihoidlas:** [Natalia kaust (DACA-group)](https://github.com/Kolju3/DACA-group/tree/main/week-4/individual/natalia)
* 📁 **Tiimi kaust tiimihoidlas:** [Tiimi töö nädal 4](https://github.com/Kolju3/DACA-group/tree/main/week-4/group)
* 📜 **Nädala SQL koodifailid:**
  * [`W4_DACA_AGGREGATIONS_IT.sql`](https://github.com/Nata376/daca-portfolio/blob/main/week-4/W4_DACA_AGGREGATIONS_IT.sql)
  * [`W4_Aggregations_GT.sql`](https://github.com/Nata376/daca-portfolio/blob/main/week-4/W4_Aggregations_GT.sql)

---

## 🚀 Kokkuvõte
Nädala 4 analüüs võimaldas muuta toored müügirida strateegiliseks juhtimisinfoks. Tuvastasime, et sõltume tugevalt kolmest põhikeskusest (Tallinn, Tartu, Pärnu toovad 72,6% käibest) ja 44 VIP-kliendist. Veebilogide tabeli puhastamine — sh algse 19 ebaühtlase allikanime koondamine selgeteks kanaliteks ning dubleerimise eemaldamine — tagas täpse 2,91 mln € käibe usaldusväärse jaotuse kanalite vahel (esikohal Google Organic 706k € ja Facebook Ads 459k €). Saadud mudelid annavad juhtkonnale usaldusväärse tööriista turunduseelarve suunamiseks ning laovarude juhtimiseks.