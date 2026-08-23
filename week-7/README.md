# 📊 UrbanStyle Python & Pandas Andmeanalüüs: 7. Nädala Kokkuvõte

Selle etapi peamine eesmärk oli liikuda SQL-päringutelt edasi täiemahulisele andmetöötlusele ja analüüsile Pythoni keskkonnas (Pandas & Plotly), integreerida Supabase'i pilveandmebaas ning viia läbi ärikriitiline **RFM kliendisegmenteerimise analüüs kogu UrbanStyle'i kliendibaasi peal**.

---

## 1. 🐍 Python, Pandas ja Supabase Integratsioon

Andmete töötlemiseks ja ettevalmistamiseks püstitati Pythoni keskkond ning teostati järgmised põhioperatsioonid:

* **Supabase'i API ühendus ja lehitsemine (Pagination):** Loodi `get_data()` funktsioon, mis laadis `while`-tsükli ja 1000-realiste lehekülgede (`range`) abil Supabase'i API limiite ületades mällu **kõik 10 118 müügirida ja 2551 unikaalset klienti**.
* **Andmebaasi JOIN-id mälus (`pd.merge`):** Müügi- (`sales`), kliendi- (`customers`) ja toodetabelid (`products`) ühendati üheks terviklikuks analüüsidega kaetud DataFrame'iks (`how='left'`).
* **Puuduvate andmete käsitlemine (NULL handling):** Tuvastati ja korrigeeriti oluline andmekaitse risk — e-poe müükidest pärit NULL asukohaväärtused (34% kogukäibest) asendati määratlusega 'E-pood' (`.fillna('E-pood')`), et vältida ligi kolmandiku käibe kadumist analüüsist.

---

## 2. 🧮 Andmete Manipuleerimine ja Agregeerimine

Rakendati Pandase edasijõudnud andmetöötluse võtteid:

* **Boolean Indexing (filtreerimine):** Tehingute filtreerimine asukohtade ja summade lõikes mitme tingimusega sümbolite `&` ja `|` abil.
* **Grupipõhine analüüs (`groupby` & `agg`):** Müügitulude, keskmiste ostude ja tehingute arvu arvutamine linnade ja tootekategooriate kaupa.
* **Tingimuspõhine funktsionaalsus (`apply` & `lambda`):** Kliendi ostusageduse ja kogukulutuste põhjal dünaamiliste väljade ning VIP-staatuste määramine.
* **Aja-analüüs:** Tekstipõhiste kuupäevade teisendamine Pandase `datetime` tüüpi ning igakuiste käibetrendide tuletamine.

---

## 3. 📉 Interaktiivne Visualiseerimine (Plotly Express)

Esitlusvalmis ja interaktiivsete graafikute loomiseks kasutati Plotly Express teeki:

* **Tulpdiagrammid (Bar Charts):** Käibe jaotus tootekategooriate kaupa koos täpsete väärtusesiltide (`text='total_price'`) ja puhastatud kujundusega (`showlegend=False`).
* **Müügitrendid (Line Charts):** Kuupõhise käibe liikumise jälgimine läbi aja koos andmepunktide märgistamisega (`markers=True`).
* **Sektordiagrammid (Pie Charts):** Kliendibaasi jaotuse visuaalne esitus VIP vs tavaklientide lõikes.
* **Mitmemõõtmelised hajuvusdiagrammid (Scatter Plots):** Neljamõõtmeline vaade (X: Recency, Y: Monetary, suurus: Frequency, värv: Segment) klientide käitumise analüüsimiseks.

---

## 📈 Ärilised Põhitulemused ja RFM Analüüs

Teostati RFM (*Recency, Frequency, Monetary*) kliendisegmenteerimine kogu andmebaasi peal, mis jagas kliendid skooride alusel nelja peamisesse ärisgmenti:

| Segment | Kirjeldus & Kliendi Käitumine | Peamine Äriline Soovitus |
| :--- | :--- | :--- |
| **VIP Champions** | Kõrgeima ostusageduse ja kulutusega kliendid. | Personaalne lojaalsusprogramm ja eksklusiivsed eelmüügid. |
| **Loyal Customers** | Tugeva kogukulutusega püsikliendid. | Ristmüük (*cross-sell*) ja meeldetuletused enne pasiivseks muutumist. |
| **Potential Loyalists** | Hiljuti ostnud kliendid madalama sagedusega. | Personaalsed soovitused ja e-maili kampaaniad teise ostu stimuleerimiseks. |
| **At Risk** | Kliendid, kelle viimasest ostust on möödas pikem aeg. | "Me igatseme teid" taaskäivitamise kampaaniad koos sooduskoodiga. |

> **Märkus:** Tervikliku andmestiku (10 000+ rida) analüüs on aluseks mudeli edasisele automaatsele käivitamisele GitHub Actionsi abil (Nädal 8).

---

## 🤖 AI Kasutamine Õpipartnerina

Selle nädala töös kasutati AI-d (Gemini) järgmistes etappides:

* **Koodi tõlkimine ja analüüs:** SQL ja Pandase süntaksi kõrvutamine (`WHERE` vs *Boolean indexing*, `GROUP BY` vs `groupby()`).
* **Andmekvaliteedi kontroll:** NULL väärtuste ärilise tähenduse tuvastamine (34% e-poe müükide säilitamine `.fillna()` abil).
* **API Pagination koodi loogika:** Supabase'i 1000-realise päringulimiidi ületamine ja `while`-tsükli silumine.
* **Plotly silumine ja renderdamine:** VS Code'i notebooki graafikute renderdajate seadistamine (`pio.renderers.default = "vscode"`).
