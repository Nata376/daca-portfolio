# 📊 UrbanStyle Python & Pandas Andmeanalüüs: 7. Nädala Kokkuvõte

Selle etapi peamine eesmärk oli liikuda SQL-päringutelt edasi täiemahulisele andmetöötlusele ja analüüsile Pythoni keskkonnas (Pandas & Plotly), integreerida Supabase'i pilveandmebaas ning viia läbi ärikriitiline **RFM kliendisegmenteerimise analüüs (1000 kliendi esindusvalimi põhjal)**.

---

## 1. 🐍 Python, Pandas ja Supabase Integratsioon

Andmete töötlemiseks ja ettevalmistamiseks püstitati Pythoni keskkond ning teostati järgmised põhioperatsioonid:

* **Supabase'i API ühendus ja lehitsemine (Pagination):** Loodi `get_data()` funktsioon Supabase'i andmebaasist andmete automaatseks pärimiseks 1000-realiste lehekülgede kaupa, et ületada API vaikelimiidid ja laadida analüüsiks vajalik andmekomplekt.
* **Andmebaasi JOIN-id mälus (`pd.merge`):** Müügi- (`sales`), kliendi- (`customers`) ja toodetabelid (`products`) ühendati üheks terviklikuks analüüsidega kaetud DataFrame'iks (`how='left'`).
* **Puuduvate andmete käsitlemine (NULL handling):** Tuvastati ja korrigeeriti oluline andmekaitse risk — e-poe müükidest pärit NULL asukohaväärtused (34% kogukäibest) asendati määratlusega 'E-pood' (`.fillna('E-pood')`), et vältida ligi kolmandiku käibe kadumist analüüsist.

---

## 2. 🧮 Andmete Manipuleerimine ja Agregeerimine

Rakendati Pandase edasijõudnud andmetöötluse võtteid:

* **Boolean Indexing (filtreerimine):** Tehingute filtreerimine asukohtade ja summade lõikes mitme tingimusega sümbolite `&` ja `|` abil.
* **Grupipõhine analüüs (`groupby` & `agg`):** Müügitulude, keskmiste ostude ja tehingute arvu arvutamine linnade ja tootekategooriate kaupa.
* **Tingimuspõhine funktsionaalsus (`apply` & `lambda`):** Kliendi ostusageduse ja kogukulutuste põhjal dünaamiliste väljade sekä VIP-staatuste määramine.
* **Aja-analüüs:** Tekstipõhiste kuupäevade teisendamine Pandase `datetime` tüüpi ning igakuiste käibetrendide tuletamine.

---

## 3. 📉 Interaktiivne Visualiseerimine (Plotly Express)

Esitlusvalmis ja interaktiivsete graafikute loomiseks kasutati Plotly Express teeki:

* **Tulpdiagrammid (Bar Charts):** Käibe jaotus tootekategooriate kaupa koos täpsete väärtusesiltide (`text='total_price'`) ja puhastatud kujundusega (`showlegend=False`).
* **Müügitrendid (Line Charts):** Kuupõhise käibe liikumise jälgimine läbi aja koos andmepunktide märgistamisega (`markers=True`).
* **Sektordiagrammid (Pie Charts):** Kliendibaasi jaotuse visuaalne esitus VIP vs tavaklientide lõikes.
* **Mitmemõõtmelised hajuvusdiagrammid (Scatter Plots):** Neljamõõtmeline vaade (X: Recency, Y: Monetary, suurus: Frequency, värv: Segment) klientide käitumise analüüsimiseks.

---

## 📈 Ärilised Põhitulemused ja RFM Analüüs (1000 Kliendi Valim)

Teostati RFM (*Recency, Frequency, Monetary*) kliendisegmenteerimine **1000 analüüsitud kliendi valimi põhjal**, mis jagas kliendid skooride alusel nelja peamisesse ärisgmenti:

| Segment | Kliendi ID-d | Peamine Tähelepanek / Äriline Soovitus |
| :--- | :--- | :--- |
| **VIP Champions** | 1001, 1004 | Moodustavad 40.6% kogukäibest (824.29 €). Vajavad personaalset lojaalsusprogrammi ja erihooldust. |
| **Loyal Customers** | 1002, 1003, 1005 | Tugeva kogukulutusega püsikliendid. NB! Suurim klient (1001) pole ostnud ~60 päeva — vajab re-aktiveerimist. |
| **Potential Loyalists** | 1007 | Hiljuti ostnud klient madalama sagedusega — sobib lisamüügi (*upsell*) pakkumisteks. |
| **At Risk** | 1006 | Vaid 1 ost, väike summa ja viimasest ostust möödas peaaegu 2 kuud. Vajab "Me igatseme teid" pakkumist. |

> **Märkus:** 1000 kliendi valimi analüüs on aluseks mudeli edasisele laiendamisele ja automaatsele segmenteerimisele kogu UrbanStyle'i kliendibaasi peal (Nädal 8).

---

## 🤖 AI Kasutamine Õpipartnerina

Selle nädala töös kasutati AI-d (Gemini) järgmistes etappides:

* **Koodi tõlkimine ja analüüs:** SQL ja Pandase süntaksi kõrvutamine (`WHERE` vs *Boolean indexing*, `GROUP BY` vs `groupby()`).
* **Andmekvaliteedi kontroll:** NULL väärtuste ärilise tähenduse tuvastamine (34% e-poe müükide säilitamine `.fillna()` abil).
* **Plotly silumine ja renderdamine:** VS Code'i notebooki graafikute tiirlema jäämise lahendamine renderdajate seadistamisega (`pio.renderers.default = "vscode"`).
