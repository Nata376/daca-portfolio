# 📊 UrbanStyle Python, Pandas ja Plotly Andmeanalüüs: 7. Nädala Terve Töövoog

Selle etapi peamine eesmärk oli liikuda SQL-päringutelt edasi täiemahulisele andmetöötlusele ja analüüsile Pythoni keskkonnas (**Pandas & Plotly**), integreerida **Supabase'i** pilveandmebaas API kaudu ning viia läbi nii eksploratiivne andmeanalüüs (EDA) kui ka ärikriitiline **RFM kliendisegmenteerimine kogu UrbanStyle'i kliendibaasi peal**.

---

## 🛠️ 1. Tehnilised Oskused ja Andmetöötluse Töövoog

Kogu nädala jooksul rakendati järgmisi Pythoni ja Pandase teegi võimalusi:

### 🐍 Supabase API Integratsioon ja Andmete Liitmine (`pd.merge`)
* **API lehitsemine (Pagination):** Supabase'i 1000-realisest päringulimitatsioonist ülesaamiseks loodi `while`-tsüklil põhinev funktsioon `get_data()`, mis laadis mällu kõik tehingute, klientide ja toodete read.
* **Mitmepoolne liitmine:** Ühendati müügitabel (`sales`), klienditabel (`customers`) ja toodetabel (`products`) ühtseks analüütiliseks mudeliks (`how='left'`).
* **Puuduvate andmete käsitlemine (`.fillna()`):** Tuvastati ja korrigeeriti e-poe müükidest pärit NULL asukohaväärtused (`.fillna('E-pood')`), mis hoidis ära ligi 34% kogukäibe kadumise analüüsist.

![Supabase ühendus ja andmete liitmine](https://github.com/Nata376/daca-portfolio/blob/main/week-7/%C3%9Chendus%20supabasega%20%2B%20andmete%20liitmine.png)

---

### 🧮 Eksploratiivne Andmeanalüüs (EDA) ja Puhastamine
* **Andmestiku struktuuri kontroll:** Kasutati päringuid `.shape`, `.head()`, `.info()`, `.describe()` ja `.dtypes` andmetüüpide ja jaotuste kiireks auditeerimiseks.
* **Unikaalsus ja summaarsed näitajad:** Kontrolliti unikaalseid kliente (`.nunique()`), asukohti/kategooriaid (`.unique()`) ning sagedusjaotusi (`.value_counts()`).
* **Andmetüüpide teisendus ja filtreerimine:** Tekstipõhised kuupäevad teisendati `datetime` kujule (`pd.to_datetime()`), eemaldati duplikaadid (`invoice_id` alusel) ja filtreeriti välja vigased/negatiivsed summaväärtused (`total_price > 0`).

![Andmete puhastamine](https://github.com/Nata376/daca-portfolio/blob/main/week-7/Andmete%20puhastamine.png)

---

### 💡 Ärilogika ja Dünamilised Veerud (SQL equivalent Pandas)
* **Filtreerimine (`WHERE` analoog):** Eraldati konkreetsete asukohtade (nt Tallinn) tellimused ning arvutati linna-põhised käibed.
* **Aggregeerimine (`GROUP BY` analoog):** Arvutati mitme statistilise näitaja koondtabelid `.agg(['sum', 'mean', 'count'])` abil (käibed, keskmised ostukorvid, tellimuste arvud).
* **Tingimuslikud veerud (`CASE WHEN` analoog):** 
  * Loomisel tellimuste suuruse kriteerium: `lambda x: 'Suur (100+)' if x >= 100 else 'Väike (<100)'`.
  * Loomisel kliendi staatus kulutuste põhjal: `lambda x: 'VIP' if x > 200 else 'Tavaline'`.
* **Ekstreemumite leidmine:** Tuvastati suurema käibega tooted (`.nlargest()`) ja enim kulutanud kliendid (`.idxmax()`).

---

## 📈 2. Ärilised Põhitulemused ja RFM Analüüs

Kogu andmebaasi peal teostati täielik **RFM** (*Recency, Frequency, Monetary*) kliendisegmenteerimine. Klientidele arvutati viimase ostu aeg, ostusagedus ja kogukulutus ning määrati kvintiilide ja skooride alusel kuus põhisegmenti:

![RFM Analüüs](https://github.com/Nata376/daca-portfolio/blob/main/week-7/RFM%20anal%C3%BC%C3%BCs.png)

| Segment | Kliendiarv | Kesk. Recency (päeva) | Kesk. Frequency | Kogukäive (€) | Osakaal % | Peamine Äriline Soovitus |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **VIP Champions** | 455 | 534.6 | 7.68 | 1 146 295.15 | 17.91% | Personaalne lojaalsusprogramm ja eksklusiivsed eelmüügid. |
| **Loyal Customers** | 415 | 612.9 | 4.14 | 528 261.92 | 16.34% | Ristmüük (*cross-sell*) ja meeldetuletused enne pasiivseks muutumist. |
| **Regular Customers** | 512 | 668.5 | 3.18 | 474 231.56 | 20.16% | Korduvostude stimuleerimine ja soovitussüsteemid. |
| **New / Potential** | 511 | 701.2 | 2.25 | 315 656.58 | 20.12% | Tervitussari (*onboarding*) ja soodustus 2. ostuks 30 päeva jooksul. |
| **At Risk** | 391 | 772.6 | 1.69 | 156 018.31 | 15.39% | "Me igatseme teid" win-back kampaaniad koos personaalse sooduskoodiga. |
| **Lost** | 256 | 926.1 | 1.17 | 56 387.02 | 10.08% | Automaatne re-aktivatsiooni viimane katse. |

---

## 📉 3. Interaktiivne Visualiseerimine (Plotly Express)

Tulemuste esitlemiseks ja trendide mõistmiseks loodi erisuguseid Plotly visualiseeringuid:

1. **Rõhtsad tulpdiagrammid (`px.bar`, orientation='h'):** Müügikäibe võrdlus tootekategooriate kaupa koos täpsete summasiltidega tulpadel.
2. **Aegrea joongraafikud (`px.line`):** Kuupäevapõhine ja kuupõhine (`dt.strftime('%Y-%m')`) müügitrendide jälgimine aja jooksul (koos markeritega).
3. **Sektordiagrammid (`px.pie`):** Klientide osakaalu kuvamine VIP-staatuse järgi koos kohandatud värvipaletiga.
4. **Tulpdiagrammid (Bar Charts):** TOP 10 VIP-kliendi ja RFM segmentide mahuline võrdlus.
5. **Neljamõõtmelised hajuvusdiagrammid (`px.scatter`):** Kliendibaasi jaotuse vaatlemine (X: Recency, Y: Monetary logaritmilisel skaalal `log_y=True`, suurus: Frequency, värv: Segment).

![Visualiseerimine](https://github.com/Nata376/daca-portfolio/blob/main/week-7/Visualiseerimine.png)

---
## 👥 Grupitöö

* 👥 **Grupitöö repositoorium GitHubis:** [DACA-group](https://github.com/Kolju3/DACA-group/tree/main/week-7/group)
* 👤 **Minu isiklik panus grupi repositooriumis:** [Natalia panus grupitöösse](https://github.com/Kolju3/DACA-group/tree/main/week-7/individual/natalia)

---

## 🤖 4. AI Kasutamine Õpipartnerina

Selle nädala töös tehti tihedat koostööd AI-ga (Gemini / ChatGPT) järgmistes etappides:

* **SQL ➡️ Pandas süntaksi tõlkimine:** SQL päringute tegemine Pandase vahenditega (`WHERE` ➡️ *Boolean indexing*, `GROUP BY` ➡️ `.groupby()`, `CASE WHEN` ➡️ `.apply(lambda)`).
* **Andmekvaliteedi analüüs:** NULL väärtuste ärilise tähenduse tuvastamine (e-poe müükide eristamine `.fillna()` abil).
* **API lehitsemise kood:** Supabase'i 1000-realise päringulimiidi ületamiseks vajaliku `while`-tsükli silumine.
* **Plotly silumine:** Graafikute skaalade häälestamine (`log_y=True`), legendide haldamine ja keskkonna seadistamine (`pio.renderers.default = "vscode"`).