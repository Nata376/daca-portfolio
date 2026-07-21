/*
==============================================================================
🚀 Nädal 0: Arenduskeskkonna ja infrastruktuuri seadistamine
==============================================================================

1. MIKS SEE PROJEKT OLEMAS ON?
------------------------------------------------------------------------------
UrbanStyle Ltd. on kiiresti kasvav ettevõte, mille andmehaldus oli jõudnud
kriitilise piirini. Seni kasutati äriotsuste tegemiseks käsitsi täidetavaid
Exceli tabeleid, mis tõi kaasa:
  - Andmete dubleerimise ja versioonihalduse puudumise (nt salestable_FINAL_v2.xlsx).
  - Ebakindlad äriotsused, kuna puudus teadmine, milline fail sisaldab tõest
    ja värskeimat informatsiooni.

Selle projekti eesmärk on asendada senine kaootiline süsteem professionaalse
andmeanalüüsi infrastruktuuriga, kus andmed asuvad kesksetes pilvesüsteemides,
kood on täielikult jälgitav ning tulemused usaldusväärselt jagatavad.


2. MIDA MA TEGIN?
------------------------------------------------------------------------------
Seadistasin kaasaegse andmeanalüütiku tööriistakomplekti (tech stack) ja koondasin
selle ühtseks toimivaks ahelaks:

  * <img src="https://img.shields.io/badge/-Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white"/> <img src="https://img.shields.io/badge/-PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white"/> Supabase (PostgreSQL):
    Seadistasin pilvepõhise andmebaasi, mis hoiab turvaliselt kõiki
    UrbanStyle'i andmeid ühes keskses kohas, ning lõin sinna esimese andmetabeli.

  * <img src="https://img.shields.io/badge/-VS%20Code-007ACC?style=flat&logo=visual-studio-code&logoColor=white"/> VS Code:
    Võtsin kasutusele integreeritud arenduskeskkonna, mille kaudu saan
    kirjutada koodi, teha SQL-päringuid ja hallata kogu oma töövoogu ühest vaatest.

  * <img src="https://img.shields.io/badge/-Git-F05032?style=flat&logo=git&logoColor=white"/> <img src="https://img.shields.io/badge/-GitHub-181717?style=flat&logo=github&logoColor=white"/> Git ja GitHub:
    Seadistasin versioonihalduse ning lõin avaliku repositooriumi. Projekti
    loogilise ülesehituse ja nädalapõhise kaustastruktuuriga saab tutvuda [minu portfoolio repositooriumis](https://github.com/Nata376/daca-portfolio).

  * <img src="https://img.shields.io/badge/-Python-3776AB?style=flat&logo=python&logoColor=white"/> Python ja virtuaalkeskkond (venv):
    Konfigureerisin isoleeritud Pythoni keskkonna (vaata [seadistuse ekraanipilti](https://github.com/Nata376/daca-portfolio/blob/main/week-0/Pyrhon%20seadistus%20.png)),
    mis võimaldab turvaliselt käivitada andmetöötlusskripte ja analüüsiteeke.
    Lisaks kontrollisin läbi skripti andmebaasiühenduse toimimist (vaata [ühenduse testi tulemust](https://github.com/Nata376/daca-portfolio/blob/main/week-0/Python%2Bsupabase%20test.png)).

  * <img src="https://img.shields.io/badge/-Jupyter-F37626?style=flat&logo=jupyter&logoColor=white"/> Jupyter Notebook:
    Lõin oma esimese Jupyter Notebooki (.ipynb) interaktiivseks andmetöötluseks
    ja analüüsiks (vaata [märkmiku vaadet siit](https://github.com/Nata376/daca-portfolio/blob/main/week-0/Jupiter%20notebook.png)).

  * 🗄️ Esmane SQL-päring ja ühenduse testimine:
    Kirjutasin oma esimese SQL-päringu [hello_urbanstyle.sql](https://github.com/Nata376/daca-portfolio/blob/main/week-0/hello_urbanstyle.sql)
    ning teostasin edukalt ühenduse testi VS Code'i ja Supabase'i vahel (kinnitav [ekraanipilt siin](https://github.com/Nata376/daca-portfolio/blob/main/week-0/VS%20code%20%2B%20supabase%20test.png)).

  * <img src="https://img.shields.io/badge/-NotebookLM-4285F4?style=flat&logo=google&logoColor=white"/> <img src="https://img.shields.io/badge/-Miro-050038?style=flat&logo=miro&logoColor=white"/> NotebookLM, RAG ja Miro (Teadmusbaas ja õppeprotsess):
    Võtsin kasutusele NotebookLM-i, kuhu lisasin RAG-failid (Retrieval-Augmented
    Generation ehk õppematerjalid ja dokumentatsiooni) isikliku teadmusbaasi
    loomiseks. Peale materjalidega tutvumist tegin kõigepealt läbi NotebookLM juhendi.
    Kuna olen visuaalne õppija, pakkus see mulle eriti suurt huvi ja tuge teemade
    kiirel süsteemsel omandamisel. Lisaks oli mulle mõtete koondamisel ja
    arhitektuuriliste seoste visuaalsel kaardistamisel suureks abiks Miro.

TULEMUS:
Kogu ahel on omavahel integreeritud – saan nüüd kõiki andmeid eri süsteemidest kätte,
neid päringutega risttöödelda ning tulemused otse VS Code'i kaudu avalikku
portfooliosse salvestada.


3. MIDA SEE NÄITAB JA MILLINE ON MÕJU?
------------------------------------------------------------------------------
  * Mõju ärile:
    UrbanStyle sai vundamendi skaleeritavale ja turvalisele andmearhitektuurile.
    Käsitsi tabelite vahetamise aeg on läbi – tulevased analüüsid põhinevad
    unikaalsel ja kontrollitud andmeallikal.

  * Analüütiku võimekus:
    Näitab valmisolekut töötada kaasaegsete andmeinseneri ja -analüütiku
    tööriistadega (SQL, Python, Git/GitHub, Cloud DB, Jupyter), mis on eeldus
    automatiseeritud raportite ja masinõppemudelite loomiseks.


## 🎯 Lõpptulemus

* ✅ **Arengukeskkond** on täielikult seadistatud ja toimiv.
* 📂 **Kõik projektifailid** (sh SQL-päring `hello_urbanstyle.sql` ja testskriptid) on edukalt ühendatud GitHubi `main` harusse.
* 🚀 **Olen seljatanud esimesed Giti ämbrid** ja saanud enesekindluse edasisteks nädalateks!
==============================================================================
*/

