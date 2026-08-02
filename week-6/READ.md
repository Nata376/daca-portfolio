# 📊 UrbanStyle Power BI Dashboard: 6. Nädala Kokkuvõte

Selle etapi peamine eesmärk oli viia toode prototüübi tasemelt juhtkonnale ja investoritele esitletavale tasemele (Shu $\rightarrow$ Ha üleminek), rakendades andmeloo esitamise (data storytelling), täpse DAX-analüütika ja visuaalse lihvimise parimaid praktikaid.

---

## 1. 🧮 Täpsem DAX-Analüütika ja Arvutused

Analüüsi ja visualiseerimise jaoks loodi järgmised mõõdikud ja arvutuslikud veerud:

* **Revenue Category (arvutuslik veerg):** Tehingute kategoriseerimine nende väärtuse alusel (High Value, Standard, Low Value).
* **Total Revenue (mõõdik):** Ettevõtte kogukäibe arvutamine (2.91M €).
* **Average Order Value / AOV (mõõdik):** Keskmise ostukorvi suuruse tuletamine (287.53 €).
* **YoY Growth (mõõdik):** Müügitulu aastase kasvu arvutamine ajakonteksti ja ohutu jagamise (DIVIDE) funktsioonidega. ([Vaata visuaalset vaadet](https://github.com/Nata376/daca-portfolio/blob/main/week-6/Iseseisev%20t%C3%B6%C3%B6_Week%206_Natalia.PNG))

---

## 2. 🎨 Visuaalne Lihvimine ja Storytelling (Andmeloo Esitamine)

Pelgalt numbrite näitamise asemel lisati visuaalidele tegevuspõhine kontekst:

* **Annotatsioonid ja tähelepanu suunamine:**
  * Detsembri müügitrendile lisati selgitav märkus: "Q4 müügitipp — jõulukampaania efekt (+35% vs november)".
  * Tulpdiagrammil toodi välja tipptoode: "Hero product: Sporditossud — 28%".
  * Asukohtade analüüsis märgitakse riskikohta: "Tartu -5% — audit vajalik".
* **Viite- ja eesmärgijooned (Analytics Paneel):** Joondiagrammile lisati sihtjoon Target €30K/kuu ja valdkonna keskmine tase (25 000.00 €).
* **Tingimuslik vormindamine (Conditional Formatting):** KPI kaardid varustati värvikoodeeringuga (roheline/oranž/punane), mis näitavad koheselt target'ite täitmist. 

*(Tutvu materjalidega: [PDF Raport](https://github.com/Nata376/daca-portfolio/blob/main/week-6/urbanstyle_week6-Storytelling_Natalia.pdf) ja [Power BI .PBIX fail](https://github.com/Nata376/daca-portfolio/blob/main/week-6/urbanstyle_week6-Storytelling_Natalia.pbix))*

---

## 3. 🎛️ Interaktsioonide Juhtimine ja Mobiilivaade

* **Interaktsioonide häälestamine (Edit Interactions):** Filtreerimiskäitumist kohandati selliselt, et sektordiagrammil linnasid või kanaleid valides uuenevad trendi- ja tootediagrammid (Filter), kuid põhilised KPI kaardid säilitavad globaalse koondvaate (None).
* **Mobiilivaade (Mobile Layout):** Seadistati eraldi nutiseadmetele optimeeritud vertikaalne vaade koos ülaseotud KPI-de, rippmenüü-sliceri ning täislaiuses diagrammidega. ([Vaata mobiilivaadet](https://github.com/Nata376/daca-portfolio/blob/main/week-6/Week_6_%20mobiilivaaade_%20Natalia.PNG))

---

## 📈 Ärilised Põhitulemused ja Mõõdikud (Sinu Andmetel)

| Mõõdik / Näitaja | Tegelik Väärtus | Peamine Tähelepanek |
| :--- | :--- | :--- |
| **Kogu müügitulu** | **2.91M €** | Ettevõtte summoarne müügikäive |
| **Tehingute arv** | **10.118K** | Teostatud tehingute koguarv |
| **Keskmine ost (AOV)** | **287.53 €** | Keskmise ostukorvi maht |
| **High Value tehingud** | **96.36%** | Valdav enamus käibest tuleb kõrge väärtusega ostudest |

### Kanalite ja Asukohtade Lõige:

* 🏬 **Tallinn** (37.54% käibest / 534.80K €): Suurim kauplus (+10.75% kasv). Tähelepanek: ~40% klientidest ei ole veel lojaalsusprogrammiga liitunud. ([Vaata Tallinna poe lugu](https://github.com/Nata376/daca-portfolio/blob/main/week-6/Tallinna%20poe%20lugu_week_6_natalia.PNG))
* 🌐 **E-pood** (34.61% käibest / 1.01M €): Tugevaim kasv (+20.46%). Suvised müügitipud (juuni-juuli) ületasid seatud 46K € eesmärgi (jõudes 55K–56K € tasemele). ([Vaata E-poe lugu](https://github.com/Nata376/daca-portfolio/blob/main/week-6/E-poe%20lugu_Natalia_week_6.PNG))
* 🏬 **Tartu** (17.93% käibest / 260.04K €): Käibe tugev kasv (+13.40%), müügitipp oli sooduskampaaniate tõttu augustis. Keskmine ost langes veidi (-2.64%). ([Vaata Tartu poe lugu](https://github.com/Nata376/daca-portfolio/blob/main/week-6/Tartu-poe%20lugu_week_6_Natalia.PNG))
* 🏬 **Pärnu** (9.93% käibest / 139.30K €): Stabiilne kasv (+4.30%). Selge suvine tippaeg (augustis 17.1K €), kuid detsembris langes müügitulu selgelt (10.2K €). ([Vaata Pärnu poe lugu](https://github.com/Nata376/daca-portfolio/blob/main/week-6/P%C3%A4rnu%20poe%20lugu%20_%20week_6_Natalia.PNG))

---

## 👥 Grupitöö

* 👥 **Grupitöö repositoorium GitHubis:** [DACA-group](https://github.com/Kolju3/DACA-group)
* 📢 **Grupitöö esitlus:** (tulemas)
* 👤 **Minu isiklik panus grupi repositooriumis:** [Natalia panus grupitöösse](https://github.com/Kolju3/DACA-group/tree/main/week-6/individual/natalia)

---

## 🤖 AI Kasutamine Õpipartnerina

Selle nädala töös kasutati AI-d (ChatGPT / Claude / Gemini) järgmistes etappides:

* **DAX valemite silumine:** YoY Growth ajakontekstipõhiste funktsioonide (CALCULATE, YEAR, TODAY) ja nulliga jagamise kaitse (DIVIDE) koostamine.
* **Visualiseerimisjuhised:** Edit Interactions loogika ja Conditional Formatting fx-reeglite korrektne seadistamine.
* **Mobiilivaate ja Storytellingu optimeerimine:** Knaflici Data Storytelling põhimõtete rakendamine (tähelepanu suunamine viitejoonte ja annotatsioonide abil).
