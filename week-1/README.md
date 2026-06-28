# 📂 Nädal 1: SQL Alused

Tere tulemast minu esimese nädala õpingute kokkuvõttesse! See nädal keskendus andmete süvaanalüüsile ja SQL-i põhitõdedele, eesmärgiga lahendada UrbanStyle'i müügitabeli andmekvaliteedi väljakutseid.

---

## 🎯 Projekti eesmärk (Äriküsimus)
Projekt keskendub **UrbanStyle'i müügiandmete kvaliteedi auditeerimisele**. Äri seisukohast on kriitiline, et andmebaasi info oleks usaldusväärne – ilma vigadeta andmeteta ei saa ettevõtte juhtkond teha õigeid strateegilisi otsuseid, prognoosida nõudlust ega hinnata tegelikku müügitulu.

---

## 🛠 Mida see nädal tegin?

* **Andmebaasi seadistamine:** Importisin products, customers ja sales andmestikud Supabase'i. Kasutasin vajadusel staging-tabelit kuupäevaformaatide ühtlustamiseks.
* **SQL baasoskused:** Õppisin koostama päringuid, kasutades SELECT, WHERE, ORDER BY ja LIMIT käske. Minu koostatud SQL-päringute ja nende vastustega saab tutvuda [siin](https://github.com/Nata376/daca-portfolio/blob/main/week-1/Week_1_IT_SQL_Alused.sql).
* **Andmeanalüüs:** Rakendasin COUNT() ja DISTINCT funktsioone, et tuvastada andmebaasi duplikaate ja tagada andmete terviklikkus. Tulemuste analüüsiga saab tutvuda [siin](https://github.com/Kolju3/DACA-group/tree/main/week-1/individual/natalia).
* **Grupitöö & Tooteandmestik:**
    * **Kvaliteedikontroll:** Valideerisin products tabeli – tulemus on 100% korras (ei ühtegi NULL-väärtust ega puuduvat hinda).
    * **Portfelli analüüs:** Analüüsisin kategooriaid ja hinnavahemikke.
* **Esitlusmaterjalid:** Koostasin meie tiimi esitluse, kasutades NotebookLM-i analüüsitulemuste visualiseerimiseks ja struktureerimiseks.

---

## 📈 Mõju äriprotsessidele
* **Andmekvaliteedi parandamine:** Avastatud duplikaadid ja asukohtade kirjapildi ebakõlad võimaldavad luua täpsemaid müügiraporteid.
* **Töö efektiivsus:** Valideeritud `products` tabel ja automatiseeritud esitlusmaterjalid tagavad, et esitletavad andmed on vigadeta.
* **Riski vähendamine:** Tuvastatud negatiivsed tehingud võimaldavad vältida ebaõigeid finantsotsuseid ja parandada aruandluse täpsust.

---

## ⚠️ Avastatud andmekvaliteedi probleemid

| Probleem | Kirjeldus | Mõju |
| :--- | :--- | :--- |
| **Kirjapildi erinevused** | "Tallinn", "tallinn", "TALLINN" jne. | 11 asukoha asemel näeme üle 50 kirjapildi. |
| **Loogikavead** | Negatiivse väärtusega tehingud sales tabelis. | Analüüsi moonutused müüginumbrites. |

---

## 🚧 Kus jäin toppama?
* **Süntaks:** Kuigi SQL-i loogika on arusaadav, tekitasid alguses segadust "pisiasjad" (komad, semikoolonid, sulud). Õppisin, et SQL-is on süntaks ülitähtis!

---

## 🎯 Lõpptulemused
- ✅ Andmebaas on korrektselt seadistatud ja andmed imporditud.
- 📂 IT-juhile suunatud raport on valmis koos põhjaliku duplikaatianalüüsiga – [loe raportit siit](https://github.com/Kolju3/DACA-group/blob/main/week-1/group/UrbanStyle_week1_operatsioonid.pdf).
- 📈 products tabel on valideeritud ja meeskonna esitlus on valmis!

---

## 🧰 Tehniline pagas
* **SQL:** SELECT, FROM, WHERE, ORDER BY, LIMIT, DISTINCT, COUNT, IS NULL
* **Tööriistad:** SQL Editor, NotebookLM, PowerPoint

---

## 🔗 Meeskonna lingid
* **GitHub Repository:** https://github.com/Kolju3/DACA-group/tree/main/week-1/individual/natalia
* **Supabase Dashboard:** https://supabase.com/dashboard/project/xwmwqxqorsiauliaynkk/sql/10b85090-f04c-4d82-b2d6-2a51fb279489
* **NotebookLM:** https://notebooklm.google.com/notebook/d18e6111-8e2d-4bba-8df7-7f9f6b3685e8
