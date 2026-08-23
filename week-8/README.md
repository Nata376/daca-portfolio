# Week 8: Andmetorude (ETL) Automatiseerimine ja Pythoni Pipeline

See kaust sisaldab 8. nädala iseseisva töö lahendusi, kus ehitati täisväärtuslik ja automatiseeritud andmetoru (ETL pipeline) alates andmete pärimisest kuni interaktiivsete raportite genereerimiseni.

---

## 🛠️ Tehtud tööd ja komponendid (Iseseisev töö)

1. **Extract (Andmete hankimine):**
   - Andmete simuleerimine ja API / andmebaasi struktuuri ettevalmistamine `pandas` andmestruktuuridena.
2. **Transform (Andmete töötlemine ja RFM analüüs):**
   - Tellimuste ja klientide andmete ühendamine (`merge`).
   - Kliendibaasi segmenteerimine RFM (Recency, Frequency, Monetary) mudeli alusel (VIP, Loyal, Regular, At Risk).
   - Kuupõhiste käiberaportite agregeerimine.
3. **Validate (Andmete valideerimine):**
   - Automaatsed kontrollid tagamaks, et andmetorus ei esine tühje või vigaseid tulemusi enne raporteerimist.
4. **Load (Salvestamine ja Visualiseerimine):**
   - Puhaste andmete eksport CSV-failidesse (`kuukayve_raport.csv`, `rfm_raport.csv`, `linnade_raport.csv`).
   - Interaktiivsete visuaalide loomine Plotly raamistikuga (`HTML` formaadis graafikud).

---

## 📁 Loodud failid
- `Week_8_IT_pipeline.py` – Põhiline täispikk ETL pipeline kood.
- `*_raport.csv` – Automatiseeritud CSV andmefailid.
- `*_graafik.html` – Interaktiivsed Plotly graafikud.

---

## 👥 Grupitöö (Lisandub peagi)
*Siia sektsiooni lisanduvad hiljem grupitöö tulemused, täiendavad analüüsid või ühise töö panused.*