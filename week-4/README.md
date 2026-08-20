# 🔗 Nädal 4: SQL Aggregations & Advanced Analytics — CEO ja Juhatuse Raport

## 📌 Lähteülesanne
> **Kristi Tamm (CEO):** *"Ma ei vaja pelgalt SQL-päringuid — ma tahan selgeid ärivastuseid juhatuse koosolekuks! Kuidas muutub meie käive kuude kaupa, kes on meie võtmekliendid, millised linnad toovad lõviosa tulust ja kus on laoseisudes käärid?"*
> 
> **Lahendus:** Kasutasime keerukaid grupeerimisi (`GROUP BY`, `HAVING`), ajutisi vahetabeleid (`CTE`) ja aknafunktsioone (`LAG()`, `ROW_NUMBER()`, `OVER (PARTITION BY)`), et koondada andmed tegevjuhi ja juhatuse jaoks strateegilisteks vastusteks.

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

### 2. Kliendianalüüs ja Segmentatsioon (`LEFT JOIN` + `CASE WHEN`)
* **Päring:** Grupeerisime kliendid nende kogukäibe alusel segmentidesse: `VIP` (> 3000 €), `Aktiivne` (1001–3000 €), `Tavaline` (1–1000 €) ja `Ostuta / Inaktiivne` (0 €) ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Segmenteeritud%20kliendid%20.png)).
* **Tulemus:**
  * **3150 kliendist** jagunesid tegelikud ostjad järgmiselt ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Klient%2Bm%C3%BC%C3%BCk%20%C3%BCle%20500%E2%82%AC.png)):
    * **VIP:** 44 klienti (keskmine käive **9 916,35 €**)
    * **Aktiivne:** 892 klienti (keskmine käive **1 559,80 €**)
    * **Tavaline:** 1615 klienti (keskmine käive **492,30 €**)
    * **Ostuta / Inaktiivne:** 599 klienti (käive **0 €**)
* **Otsus Kristile:** Eraldi tähelepanu vajavad 44 VIP-klienti, kes toovad ebasuproportsionaalselt suure osa käibest, ning 599 registreerunud kasutajat, kes vajavad esimese ostu stiimulit.

---

### 💡 Soovitused ABC / Segmentatsioonianalüüsi Põhjal

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
  * Lahendasime selle `COALESCE(..., 0)` funktsiooniga ning täiendasime protsendiarvutust `CASE WHEN` loogikaga, vältimiseks matemaatilist 0-ga jagamise viga.

---

### 4. Tooteanalüüs: TOP 3 Toodet Kategooriate Lõikes (`ROW_NUMBER()`)
* **Päring:** Ühendasime `products` ja `sales` tabelid ning kasutasime partitsioneerimist `ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(quantity) DESC)`, et leida iga kategooria müügihitid ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/kategooria%20TOP%203%20toodet.png)).
* **Kategooriate mahud:** Analüüsitud ka kategooriaid, kus müüdud kogus ületas 500 ühikut ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Kategooria%20m%C3%BC%C3%BCgid%20%C3%BCle%20500tk.png)).
* **Miks `PARTITION BY` oli vajalik:** Ilma partitsioonita oleks päring tagastanud kogu kaupluse peale 3 populaarseimat toodet. `PARTITION BY p.category` taaskäivitas numeratsiooni iga kategooria alguses uuesti, andes täpse TOP 3 ülevaate igale tootegrupile eraldi.

---

## 🔗 SQL Päringud ja Hoidla Lingid

* 📁 **Minu kaust tiimihoidlas:** [Natalia kaust (DACA-group)](https://github.com/Kolju3/DACA-group/tree/main/week-4/individual/natalia)
* 📁 **Tiimi kaust tiimihoidlas:** [Tiimi töö nädal 4](https://github.com/Kolju3/DACA-group/tree/main/week-4/group)
* 📜 **Nädala SQL koodifail:** [`W4_DACA_AGGREGATIONS_IT.sql`](https://github.com/Nata376/daca-portfolio/blob/main/week-4/W4_DACA_AGGREGATIONS_IT.sql)

---

## 🚀 Kokkuvõte
Nädala 4 analüüs võimaldas muuta toored müügirida strateegiliseks juhtimisinfoks. Tuvastasime, et ettevõte sõltub tugevalt kolmest põhikeskusest (Tallinn, Tartu, Pärnu toovad 72,6% käibest) ja 44 VIP-kliendist. Saadud mudelid ja välja töötatud soovitused annavad juhtkonnale täpsed tööriistad turunduseelarve suunamiseks, kampaaniate automatiseerimiseks ning laovarude juhtimiseks.
