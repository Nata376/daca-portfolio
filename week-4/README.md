# 🔗 Nädal 4: SQL Aggregations & Advanced Analytics — CEO ja Juhatuse Raport

## 📌 Lähteülesanne
> **Kristi Tamm (CEO):** *"Ma ei vaja pelgalt SQL-päringuid — ma tahan selgeid ärivastuseid juhatuse koosolekuks! Kuidas muutub meie käive kuude kaupa, kes on meie võtmekliendid, millised linnad toovad lõviosa tulust ja kus on laoseisudes käärid?"*
> 
> **Lahendus:** Kasutasime keerukaid grupeerimisi (`GROUP BY`, `HAVING`), ajutisi vahetabeleid (`CTE`) ja aknafunktsioone (`LAG()`, `ROW_NUMBER()`, `OVER (PARTITION BY)`), et koondada andmed tegevjuhi ja juhatuse jaoks strateegilisteks vastusteks.

---

## 📊 Analüüsi Tulemused ja Ärivastused Juhatusele

### 1. CEO Raport: Regionaalne Top 5 ja Igakuine Trend
* **Päring:** Ehitasime kaheastmelise CTE-päringu (`linna_myyk` ja `linna_jarjestus`), kus filtreerisime välja väikesed piirkonnad (`HAVING COUNT > 5`), arvutasime linna osakaalu kogu käibest aknafunktsiooniga `SUM() OVER ()` ning võrdlesime detsembri käivet eelmiste kuude keskmisega.
* **Tulemus ja regionaalne jaotus:**
  1. **Tallinn:** 1800 tellimust | **499 652,62 €** | **37,8% kogu käibest** (Detsember: 56,5k € vs keskmine 40,3k €)
  2. **Tartu:** 908 tellimust | **262 593,48 €** | **19,9% kogu käibest** (Detsember: 29,8k € vs keskmine 21,2k €)
  3. **Pärnu:** 644 tellimust | **196 675,23 €** | **14,9% kogu käibest** (Detsember: 24,6k € vs keskmine 15,6k €)
  4. **Narva:** 204 tellimust | **60 026,30 €** | **4,5% kogu käibest**
  5. **Viljandi:** 193 tellimust | **51 761,90 €** | **3,9% kogu käibest**
* **💡 Olulisemad järeldused Kristile:**
  * **Kõrge kontsentratsioonitase:** TOP 3 linna (Tallinn, Tartu, Pärnu) toovad kokku **72,6% kogu ettevõtte käibest** (Tallinn üksi annab ligi 38%).
  * **Erinevus #1 ja #5 vahel:** Tallinna käive ületab Viljandi käivet ligi **9,6-kordselt** (vahe on **447 890,72 €**).
  * **Aasta lõpu müügisööst:** Kõigis TOP 5 linnades ületas detsembri käive märgatavalt aasta varasemate kuude keskmist, näidates tugevat pühadehooaega.

---

### 2. Kliendianalüüs ja Segmentatsioon (`LEFT JOIN` + `CASE WHEN`)
* **Päring:** Grupeerisime kliendid nende kogukäibe alusel segmentidesse: `VIP` (> 3000 €), `Aktiivne` (1001–3000 €), `Tavaline` (1–1000 €) ja `Ostuta / Inaktiivne` (0 €).
* **Tulemus:**
  * **3150 kliendist** jagunesid tegelikud ostjad järgmiselt:
    * **VIP:** 44 klienti (keskmine käive **9 916,35 €**)
    * **Aktiivne:** 892 klienti (keskmine käive **1 559,80 €**)
    * **Tavaline:** 1615 klienti (keskmine käive **492,30 €**)
    * **Ostuta / Inaktiivne:** 599 klienti (käive **0 €**)
* **Otsus Kristile:** Eraldi tähelepanu vajavad 44 VIP-klienti, kes toovad ebasuproportsionaalselt suure osa käibest, ning 599 registreerunud kasutajat, kes vajavad esimese ostu stiimulit.

---

### 3. Igakuine Käibe Kasv ja Dünamika (`LAG()` Window Function)
* **Päring:** Kasutasime `DATE_TRUNC('month', sale_date)` ja aknafunktsiooni `LAG()`, et arvutada igakuine käibekasv nii absoluutnumbris kui protsentides.
* **Märkus andmekvaliteedi kohta:**
  * Kui kliendi lõikes puudus eelneva kuu ost, tagastas `LAG()` algselt `NULL`-i.
  * Lahendasime selle `COALESCE(..., 0)` funktsiooniga ning täiendasime protsendiarvutust `CASE WHEN` loogikaga, vältimiseks matemaatilist $0$-ga jagamise viga.

---

### 4. Tooteanalüüs: TOP 3 Toodet Kategooriate Lõikes (`ROW_NUMBER()`)
* **Päring:** Ühendasime `products` ja `sales` tabelid ning kasutasime partitsioneerimist `ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(quantity) DESC)`, et leida iga kategooria müügihitid.
* **Miks `PARTITION BY` oli vajalik:** Ilma partitsioonita oleks päring tagastanud kogu kaupluse peale 3 populaarseimat toodet. `PARTITION BY p.category` taaskäivitas numeratsiooni iga kategooria alguses uuesti, andes täpse TOP 3 ülevaate igale tootegrupile eraldi.

---

## 🔗 SQL Päringud ja Hoidla Lingid

* 📁 **Minu kaust tiimihoidlas:** [Natalia kaust (DACA-group)](https://github.com/Kolju3/DACA-group/tree/main/week-4/individual/natalia)
* 📁 **Tiimi kaust tiimihoidlas:** [Tiimi töö nädal 4](https://github.com/Kolju3/DACA-group/tree/main/week-4)
* 📜 **Nädala SQL koondpäringud:** [`Week_4_Aggregations_and_Analytics.sql`](https://github.com/Nata376/daca-portfolio/blob/main/week-4/Week_4_Aggregations_and_Analytics.sql)

---

## 🚀 Kokkuvõte
Nädala 4 analüüs võimaldas muuta toored müügirida strateegiliseks juhtimisinfoks. Tuvastasime, et ettevõte sõltub tugevalt kolmest põhikeskusest (Tallinn, Tartu, Pärnu give 72.6% käibest) ja 44 VIP-kliendist. Saadud mudelid annavad juhtkonnale tööriistad nii turunduseelarve täpsemaks suunamiseks kui ka laovarude juhtimiseks.
