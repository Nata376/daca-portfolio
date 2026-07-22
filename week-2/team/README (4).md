# Nädal 2: Andmekvaliteedi audit ja SQL puhastamine (UrbanStyle.ltd)

## Meeskond: Operations Intelligence
| Roll | Nimi | Ülesanne |
| :--- | :--- | :--- |
| **Roll A** | **Olga** | Müügiandmete puhastaja: duplikaatide ja NULL-väärtuste tuvastamine müügitabelis. |
| **Roll B** | **Helen** | Kliendiandmete puhastaja: e-mailide unikaalsus ja linnanimede normaliseerimine. |
| **Roll C** | **Kalju** | Tooteandmete puhastaja: hinnakirja loogikavead ja tooteduplikaadid. |
| **Roll D** | **Natalia** | Kvaliteedikontrollija: tabelitevaheline ristvalideerimine ja finantsmõju analüüs. |

---

## 1. Kontekst ja metoodika
UrbanStyle’i andmekvaliteedi audit keskendus kolmele kriitilisele domeenile (müük, kliendid, tooted), et peatada finantslekked ja luua alus usaldusväärseks analüüsiks. Tööprotsess järgis rangelt **"Kliinilise andmekirurgia"** metoodikat:
1. **Test-koopia loomine** (`CREATE TABLE ... AS SELECT`) – algandmeid ei muudetud ilma valideeritud testita.
2. **Puhastamine** – SQL-skriptide rakendamine anomaaliate tuvastamiseks.
3. **Kontroll** – tulemuste ristvalideerimine.
4. **Dokumenteerimine** – leidude logimine ja raporti koostamine.

---

## 2. Andmekvaliteedi koondraport (Süntees)

| MEESKOND: Operations Intelligence | NÄDAL: 2 | TEGELANE: Toomas Kask |
| :--- | :--- | :--- |
| **PEAMISED LEIUD:** | | |
| 1. **Müük (Olga)** | Leitud **6603** probleemi | **5116 duplikaatset tellimust** paisutavad kunstlikult käivet; 1487 müüki on ilma kliendi viideta. |
| 2. **Kliendid (Helen)** | Leitud **762** probleemi | **130 duplikaatset e-maili** (128 unikaalset aadressi) ja **252 rida** vigaste linnanimedega (SQL tuvastas 54 linna tegeliku 12 asemel). |
| 3. **Tooted (Kalju)** | Leitud **22** probleemi | **10 toodet müüakse kahjumiga** (omahind > jaehind) ja 12 tootenime esineb duplikaadina. |
| 4. **Kontroll (Natalia)** | Leitud **1268** probleemi | **664 juhul** ei klapi müügihind tootehinnakirjaga; tuvastati 592 uinunud "vaimklienti". |
| **SUURIM ÜLLATUS:** | | |
| **SQL-loogika vs Inimloogika:** Näiliselt tühised vormistusvead (tühikud ja suurtähed) tekitasid andmebaasi 42 "fantoomlinna". Lisaks on loogilised vead (negatiivne marginaal) ohtlikumad kui NULL-id, kuna need moonutavad kasumlikkust märkamatult. | | |
| **SOOVITUS TOOMASELE:** | | |
| Prioriteet on **peatada otsene finantsleke**: korrigeerida 664 hinnahälvet ja 10 kahjumlikku toodet. Alles seejärel tegeleda 592 vaimkliendi aktiveerimisega. | | |
| **PUUDUVAD ANDMED:** | | |
| Kliendibaasis puuduvad **ajatemplid** (`created_at`) ja **andmeallika info**, mis muudab 130 duplikaadi ohutu eemaldamise (ilma teadmata, milline on värskeim kirje) riskantseks. | | |

---

## 3. Strateegiline tegevuskava
Analüüsi põhjal on koostatud kolmeastmeline ravimeetod:
*   **SAMM 1: PEATA KAHJU (Kohe):** Dedubleerida müügiandmed ja ühtlustada müügihinnad hinnakirjaga.
*   **SAMM 2: AKTIVEERI TULU (Järgmisena):** Käivitada suunatud kampaania registreeritud vaimklientidele, kellel on ostuajalugu null.
*   **SAMM 3: OPTIMEERI KULU (Hiljem):** Auditeerida 12 vaimtoodet, mida pole kunagi müüdud, ja otsustada nende sortimendist eemaldamine.

---

## 4. Tehniline integratsioon ja failid
Kõik SQL-puhastusskriptid ja individuaalsed raportid asuvad GitHubi kaustas `week-2/individual/`. Enne nädala 3 JOIN-analüüse tuleb rakendada valideeritud skriptid originaaltabelitele.

*   **Olga (Müük):** [week2_sales_cleaning](https://github.com/Kolju3/DACA-group/tree/main/week-2/individual/olga)
*   **Helen (Kliendid):** [week2_customers_cleaning](https://github.com/Kolju3/DACA-group/tree/main/week-2/individual/helen)
*   **Kalju (Tooted):** [week2_products_cleaning](https://github.com/Kolju3/DACA-group/tree/main/week-2/individual/kalju)
*   **Natalia (Ristvalideerimine):** [week2_cross_validation](https://github.com/Kolju3/DACA-group/tree/main/week-2/individual/natalia)

---
*See raport on osa DACA (Data Analyst Career Accelerator) programmist õppeeesmärkidel.*

