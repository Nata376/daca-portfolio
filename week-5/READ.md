# 📊 DACA Nädal 5: Visualiseerimise Disain — Aruanne

---

## 👤 OSA 1: Iseseisev Töö

> *"Halb dashboard on hullem kui tabel, sest ta NÄIB, nagu annaks vastuseid — aga tegelikult segab."*

### 🎯 Ülevaade ja Eesmärk
Selle nädala eesmärk oli lahendada Kristi ja Anna püstitatud ülesanne: **kuidas muuta 1247 müügirida üheks selgeks ekraaniks, mis veenab investoreid 30 sekundiga.**

---

### 🛠️ Planeerimise Etapid (Samm-sammuline teekond)

Enne Power BI-s ehitama asumist läbisin järgmised disaini- ja planeerimisetapid:

1. **Äriküsimuste kaardistamine (Sisu fokuseerimine)**
   * Mõtestasin lahti Kristi ja investorite vajadused: *Kas me kasvame? Mis tooted müüvad? Kust tulevad kliendid?*
   * Seadsin eesmärgiks, et iga visuaal peab vastama otse ühele äriküsimusele ilma üleliigse mürata.

2. **Diagrammitüüpide valik (Storytelling)**
   * Valisin igale küsimusele sobiliku struktuuri: ajatrendile **joondiagramm**, edetabelile **horisontaalne tulpdiagramm** ja osakaaludele **sõõrikdiagramm**.

3. **Paberil kavandamine (Wireframing & Z-muster)**
   * Visandasin paberil töölaua paigutuse, arvestades inimsilma liikumist (Z-muster).
   * Kujundasin töölaua vastavalt Ettevõtluskeskuse värvipaletile:
     * **Peamine aktsent:** `#009B8D` *(Teal)*
     * **Teine värv:** `#1A1A2E` *(Navy)*
     * **Kolmas värv:** `#6B7280` *(Hall)*
     * **Tekst:** `#1A1A2E`
     * **Lehe taust:** `#F3F4F6` *(Helehall)*
     * **Visuaalide kaardi taust:** `#FFFFFF` *(Valge)*

4. **Data-Ink Ratio audit (Puhastamine)**
   * Planeerisin visuaalse müra vähendamise: eemaldasin liigsed komakohad ja ruudustikujooned ning ümardasin numbrid tuhandeteni (`K` ja `M`), et tagada kiire loetavus.

5. **Teostus ja interaktiivsuse häälestus (Power BI)**
   * Ühendasin andmebaasi (`Supabase`), kohandasin teema (*Theme*), ehitasin visuaalid ning häälestasin ristelemendid (*Cross-filtering*) ja filtrid.

---

### 💡 Äriküsimused ja Visuaalsed Lahendused

#### 1. Diagrammitüüpide Valik
* **Müügitrendid kuude kaupa (`Joondiagramm`)**
  * **Äriküsimus:** *Kas me kasvame?*
  * **Tulemus:** Näitab selgelt käibe kõikumist ja hooajalisust (miinimum **Märts €202K**, tipp **Detsember €305K**).
* **Top tooted (`Horisontaalne tulpdiagramm`)**
  * **Äriküsimus:** *Mis tooted müüvad?*
  * **Tulemus:** TOP 10 toodet on parema loetavuse huvides järjestatud pikemate nimedega horisontaalselt (**Õhuline sünteetiline sporditoode €27K**, **Trendikas goretex oxfordid €23K** jne).
* **Müügikohtade osakaal (`Sõõrikdiagramm`)**
  * **Äriküsimus:** *Kust tulevad kliendid?*
  * **Tulemus:** Näitab täpseid proportsioone — **Tallinn (€1.09M / 37.54%)** ja **Online (€1.01M / 34.61%)** moodustavad kahe peale üle 72% kogu käibest.

#### 2. Filtrid ja Interaktiivsus
* **Kuupäevariba (`Slicer slider`):** Laseb kasutajal suumida konkreetsesse ajavahemikku.
* **Müügikoha filter (`Dropdown` menüü):** Võimaldab isoleerida konkreetse kaupluse või e-poe näitajad.
* **Ristfiltreerimine (`Cross-filtering`):** Klikkides sõõrikdiagrammil nt **"Tallinn"** või **"Online"**, kohanduvad joondiagramm ja TOP-tooted automaatselt vastava asukoha andmetega.

---

## 👥 OSA 2: Grupitöö Rollid ja Tulemused

### 1. CEO Dashboard: Tulemused 2023 vs 2024 (Kristi Vaade)

* **Päring / Andmed:** Võrdlesime 2023. ja 2024. aasta müüginumbreid kuude lõikes (📸 [Tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-5/Roll%20A%20-%20CEO%20dashboard.PNG)).
* **Tulemused:**
  * **Käibe kasv:** 2024. aasta käive oli **1.47M €** (kasv **+19.1%** vs 2023: **1.23M €**).
  * **Kliendibaasi kasv:** Klientide arv tõusis **2 114-ni** (kasv **+20.4%** vs 2023: **1 756**).
  * **Stabiilne trend:** 2024. aasta müügijoon püsib läbi terve aasta stabiilselt kõrgemal eelmise aasta tasemest. Peakuu on detsember (**171K €**).
* **💡 Otsus Kristile:** Ettevõtte kasv on stabiilne ja kantud e-poe kiirest arengust. Aasta lõpu müügitipuks tuleb ladu varakult ette valmistada.

---

### 2. Marketing Dashboard: Müügikanalid ja Klientide Konversioon (Anna Vaade)

* **Päring / Andmed:** Rühmitasime kliendid ostukäitumise ja füüsiliste poodide vs e-poe kaupa (📸 [Tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-5/ROLL%20B%20-%20Marketing%20dashboard.PNG)).
* **Tulemused:**
  * **Käibejaotus:** Kaupluste võrk toob **1.90M € (65%)** vs Online **1.01M € (35%)**.
  * **Linnade järjestus:** Tallinn on suurim turg (**1.79K klienti**), järgnevad Tartu (**1.12K**) ja Pärnu (**0.75K**).
  * **⚠️ KRIITILINE POTENTSIAAL:** Andmebaasis on **599 registreeritud kasutajat**, kes pole sooritanud veel ühtegi ostu!
* **💡 Soovitus Turunduseelarve Suunamiseks (Annale):**
  * Suunata turundus eelkõige Tallinnale ja e-poele (moodustavad 72% käibest).
  * Aktiveerida 599 ostuta kliendi sihtrühm personaalse tervitusboonusega.

---

### 3. Operations Dashboard: Inventuur ja Laoseisu Optimeerimine (Liisi Vaade)

* **Päring / Andmed:** Analüüsisime kaubavarude mahtu, ostuväärtust ja müügiväärtust kategooriate kaupa (📸 [Tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-5/ROLL%20C%20-%20Operatsioonid%20dashboard.PNG) ning täiendav [Lao ostuväärtuse kontrolli tõend](https://github.com/Nata376/daca-portfolio/blob/main/week-5/Kontroll%20ostuv%C3%A4%C3%A4rtusest.PNG)).
* **Tulemused:**
  * **Lao üldmaht:** Laos seisab kokku **377K ühikut** kaupa.
  * **Kapitali seotus:** Lao ostuväärtus on **44.24M €** ja eeldatav müügiväärtus **67.54M €**.
  * **Peamised laoseisud:** Kõige rohkem kapitali seisab pealaos meeste riiete (**>101K ühikut**) ja jalanõude (**~86K ühikut**) all.
* **⚠️ Ohumärk Operations'ile:** 2,9M € aastakäibe juures on 44,24M € ostuväärtuses laovaru liiga suur ja hoiab rahavoogusid kinni. Vajalik on kiire laoseisu optimeerimine!

---

### 4. Investor Dashboard: Äri Koondvaade ja Süntees

* **Päring / Andmed:** Ühendasime juhtkonna ja investorite jaoks olulisimad KPI-d ühele töölauale (📸 [Tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-5/Roll%20D%20-%20Inevstor%20dashboard.PNG)).
* **Tulemused:**
  * **Kogutulu:** **2.91M €**
  * **Kliendid kokku:** **2 552**
  * **Keskmine ostukorv (AOV):** **288 €** (püsib stabiilne läbi kuude).
* **💡 Valideeritud Ärisüntees Juhtkonnale:**
  1. **Kasvumootor:** Ettevõtte kasv on kantud klientide arvu tõusust (**+20.4%**), mitte hinnatõusust.
  2. **Rahavoogude vabastamine:** Alustada meeste riiete ja jalanõude tühjendusmüüki, et vabastada laost kapitali.
  3. **Turunduse fookus:** Tallinn ja Online annavad lõviosa käibest — hoida reklaamieelarve seal kõige kõrgemana.

---

## 🔗 Olulised Lingid ja Materjalid

* **📊 Power BI töölaua fail (.pbix):** [urbanstyle_week5_dashboard_Natalia_C.pbix](https://github.com/Nata376/daca-portfolio/blob/main/week-5/urbanstyle_week5_dashboard_Natalia_C.pbix) *(Erinevad rollid ja vaated on lahendatud failis eraldi lehtedel)*
* **👥 Grupitöö repositoorium GitHubis:** [DACA-group / week-5 / group](https://github.com/Kolju3/DACA-group/tree/main/week-5/group)
* **📢 Grupitöö esitlus:** [Urbanstyle_Week_5 Operatsioonid.pptx](https://github.com/Kolju3/DACA-group/blob/main/week-5/group/Urbanstyle_Week_5%20Operatsioonid.pptx)
* **👤 Minu isiklik panus grupi repositooriumis:** [DACA-group / week-5 / individual / natalia](https://github.com/Kolju3/DACA-group/tree/main/week-5/individual/natalia)

---

### 🤖 AI Kasutamine
AI-d kasutati SQL päringute (`DATE_TRUNC`, `GROUP BY`) ja DAX mõõdikute optimeerimiseks ning disainipõhimõtete kontrollimiseks vastavalt *Cole Nussbaumer Knaflic* visualiseerimismudelile.
