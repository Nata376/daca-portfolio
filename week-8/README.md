# 📊 UrbanStyle Pythoni Automatiseerimine: 8. Nädala Andmepipeline'i Töövoog

Selle etapi peamine eesmärk oli automatiseerida 7. nädala andmeanalüüsi protsess, luues täisväärtusliku ja automatiseeritud andmetoru (ETL pipeline) alates andmete pärimisest kuni interaktiivsete raportite ja visualiseeringute genereerimiseni.

---

## 🛠️ 1. Tehnilised Oskused ja Andmetorustiku Komponendid (Iseseisev töö)

Kogu nädala jooksul ehitati üles terviklik andmetöötluse protsess, mis jaguneb neljaks peamiseks etapiks:

1. **Extract (Andmete hankimine):**
   - Supabase API integratsioon ja lehitsemine (`pagination`), et pärida mällu KÕIK müügitehingute read ilma 1000-realise limiidita ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-8/Week_8_IT_pipeline.py)).
   - Keskkonnamuutujate turvaline haldus (`python-dotenv`) turvaliseks andmebaasiga ühendumiseks.
2. **Transform (Andmete töötlemine ja RFM analüüs):**
   - Müügi- ja kliendiandmete ühendamine (`merge`) ning andmete puhastamine (duplikaatide ja vigaste summade eemaldamine).
   - Kliendibaasi segmenteerimine RFM (*Recency, Frequency, Monetary*) mudeli alusel.
   - Kuupõhiste ja nädalaste käiberaportite agregeerimine (`resample('W')`).
3. **Validate (Andmete valideerimine):**
   - Automaatsed kontrollid tagamaks, et andmetorus ei esine tühje või vigaseid tulemusi enne raporteerimist.
4. **Load / Export (Salvestamine ja Visualiseerimine):**
   - Puhastatud andmete automaatne eksport CSV-failidesse (`kuukayve_raport.csv`, `rfm_raport.csv`, `linnade_raport.csv`) ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-8/kuukayve_raport.csv)).
   - Interaktiivsete visuaalide loomine Plotly raamistikuga ja salvestamine HTML-formaadis graafikutena ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-8/kuukayve_graafik.html)).

---

## 🚀 2. Koodi Käivitamine ja Automatiseerimine

* **Töövoo käivitamine terminalis:** Kogu automatiseeritud andmetorustiku käivitamine üheainsa käsuga (`python3 Week_8_IT_pipeline.py`), mis teostab järjestikku andmete pärimise, valideerimise, töötlemise ja failide eksportimise ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-8/Week_8_IT_pipeline.py)).

---

## 🤖 3. AI Kasutamine Õpipartnerina

Selle nädala töös tehti tihedat koostööd AI-ga (Gemini) järgmistes etappides:

* **Monoliitse skripti struktureerimine:** 7. nädala koodi ühendamine üheks toimivaks automatiseeritud skriptiks ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-8/Week_8_IT_pipeline.py)).
* **Supabase mahupiirangute ületamine:** Lehekülgede kaupa pärimise (`range` ja `while`-tsükkel) loogika seadistamine, et tuua sisse kogu andmebaas ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-8/week_8_gt_python_API.py)).
* **Automaatne failide eksport ja valideerimine:** Kaustade dünaamilise loomise ning andmete puhtuse kontrollimise programmeerimine ([📸 tõend GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-8/Week_8_IT_pipeline.py)).

---

Käivita automatiseerimise skript terminalis:

Bash
python3 automaatika.py
Tulemused ja graafikud genereeritakse ja salvestatakse automaatselt output/ kausta!
