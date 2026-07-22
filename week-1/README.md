# 📋 UrbanStyle.ltd Andmebaasi Auditi Raport

---

## 1. Projekti taust ja eesmärk

**UrbanStyle.ltd** on viimase kahe aasta jooksul kasvanud kiiresti (**+150%**). Ettevõtte andmebaas koondab müügi-, kliendi-, toote- ja kaupluste andmeid, kuid andmestikku pole varem süstemaatiliselt auditeeritud.

### 💬 Toomas Kase (IT-direktor) lähteülesanne:
> *"Ma ei usalda neid andmeid. Kas keegi saab mulle öelda, mis tabelites üldse on? Mitu rida? Mis veerud? Mis on puudu? Ma tahan IGA tabeli kohta eraldi raportit — enne kui me midagi muud teeme, peame teadma, millised andmed meil on ja mis seisus need on."*

**Analüüsi eesmärk:** Viia läbi UrbanStyle'i SQL andmebaasi esmane audit, tuvastada andmete terviklikkus, hinnata nende usaldusväärsust äriotsuste tegemiseks ning anda tegevuskava andmekvaliteedi parandamiseks.

---

## 2. Minu tööprotsess ja analüüsimeetodid

### 🛠️ Tööriistad ja keskkond
Analüüsi läbiviimiseks kasutasin **Visual Studio Code (VS Code)** keskkonda.
* **Miks VS Code, mitte Supabase?** 
  * VS Code võimaldab jooksutada mitut päringut korraga ning kuvada tulemused korraga eraldi akendes/vahekaartides. Tulemuste ahelas orienteerumine on seetõttu oluliselt ajasäästlikum.
  * VS Code pakub päringute kirjutamisel automaatseid soovitusi (autocompletion), mis toetab õppeprotsessi palju paremini kui Supabase (kus peaks päringuid kas täiesti peast kirjutama või mujalt *copy-paste* meetodil kopeerima).

### 🔍 Kasutatud SQL funktsioonid ja meetodid
Andmebaasi analüüsimiseks ja andmekvaliteedi kontrollimiseks kasutasin järgmisi SQL funktsioone ja klausleid:

* **Andmete ülevaade ja piiramine:** `SELECT *`, `LIMIT` (esmaste ridade ja veergude vaatlemiseks).
* **Ridade ja unikaalsete väärtuste loendamine:** `COUNT(*)`, `COUNT(veerg)`, `DISTINCT` (koguarvude ja unikaalsete kirjete leidmiseks).
* **Puuduvate (NULL) väärtuste ja duplikaatide tuvastamine:** Matemaatilised tehted aggregate-funktsioonidega `COUNT(*) - COUNT(veerg)` (puuduvate eesnimede ja e-mailide leidmiseks) ning `COUNT(*) - COUNT(DISTINCT e-mail)` (duplikaatide tuvastamiseks).
* **Filtreerimine ja kuupäevade vahemikud:** `WHERE` koos võrdlusoperaatoritega (nt konkreetse linna klientide või viimase 6 kuu registreerimiste filtreerimiseks).
* **Agregeerimine ja rühmitamine:** `GROUP BY` (andmete koondamiseks linnade kaupa) ning `MIN()` / `MAX()` (vanima ja uusima registreerimiskuupäeva leidmiseks).
* **Sorteerimine:** `ORDER BY` (`ASC` / `DESC`) tulemuste järjestamiseks.

---

## 3. Auditi tulemused tabelite kaupa

### 📊 3.1. Müügiandmete tabel (`Sales`)
* **Ridade arv:** 15 234 rida
* **Müügikanalid (2):** `Online` ja `Pood`
* **Tehingute väärtused:**
  * Suurim müük: **2 170,40 €**
  * Tegelik väikseim müük: **15,09 €** *(Tuvastatud ka väärtus -1405,20 €, mis viitab tagastustele või sisestusvigadele)*
* **Maksemeetodid (3):** Kaart, Järelmaks, Sularaha
* **Asukohad:**
  * E-poe tellimused: **5 204** (asukoht tühi/NULL)
  * Kaupluste müügid: Tartu (**2 708**) ja Pärnu (**1 618**)
* **Kriitilised vead:**
  * **5 116 müügiridade duplikaati** (moonutavad käibearvutusi).
  * **1 487 müügitehingul puudub kliendi ID**.
  * Tuvastatud **tuleviku kuupäevaga tehingud**.

---

### 📦 3.2. Toodete tabel (`Products`)
* **Toodete arv:** 362 toodet
* **Hinnaklass:** Kallim toode **434,00 €**, odavaim **13,58 €**
* **Tootekategooriad (5):** `Jalanõud`, `Lasteriided`, `Aksessuaarid`, `Naiste_riided`, `Meeste_riided`
* **Seisukord:** Andmed on puhtad — ühelgi tootel ei puudu hind (0 tühja väärtust).

---

### 👥 3.3. Klientide tabel (`Customers` / `Clients`)
* **Klientide koguarv:** 3 150 klienti (viimase poole aasta jooksul liitunud **425 uut klienti**).
* **E-mailide statistika:** 2 640 unikaalset e-maili ja 380 puuduvat e-maili.
* **Kriitilised vead:**
  1. **Linnade nimekiri on korrastamata:** Tuvastatud **54 erinevat linna nime** ebaühtlase kirjapildi tõttu (nt `Tallinn`, `TALLINN`, `tallinn`). Kliendianalüüs linnade kaupa pole hetkel võimalik.
  2. **510 e-maili duplikaati**.
  3. Osadel klientidel puudub märge lojaalsusprogrammiga liitumise kohta.

---

## 4. Kokkuvõte: Kas andmeid saab usaldada?

> ❌ **Vastus Toomas Kasele:** **EI, hetkeseisuga ei saa andmeid äriotsusteks ega raporteerimiseks usaldada.**

Kuigi üldmahud näivad esmapilgul suured, moonutavad enam kui **5 000 müügiduplikaati**, **standardiseerimata linnanimed**, **tuleviku kuupäevad** ja **puuduvad kliendiseosed** kõiki ärianalüütika tulemusi.

---

## 5. Soovitused edasiseks tegevuseks

1. **Duplikaatide eemaldamine:** Eemaldada topeltread müügi- ja klienditabelitest ning isoleerida negatiivsed summad tagastuste moodulisse.
2. **Tekstiväljade korrastamine:** Ühtlustada linnanimede kirjapilt, et võimaldada regionaalset kliendianalüüsi.
3. **Andmete seostamine ja reeglite seadmine:** Tuvastada ja parandada süsteemiveast tingitud tulevikukuupäevad, määrata e-poe müükidele vaikimisi asukoht ning seada piirangud, mis takistavad uute vigaste andmete tekkimist.

---

## 🔗 Meeskonna lingid

* 📁 **GitHub Repository:** https://github.com/Kolju3/DACA-group/tree/main/week-1/individual/natalia
* ⚡ **Supabase Dashboard:** https://supabase.com/dashboard/project/xwmwqxqorsiauliaynkk/sql/10b85090-f04c-4d82-b2d6-2a51fb279489
* 🧠 **NotebookLM:** https://notebooklm.google.com/notebook/d18e6111-8e2d-4bba-8df7-7f9f6b3685e8
