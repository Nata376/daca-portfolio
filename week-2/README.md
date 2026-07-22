# Nädal 2: SQL Cleaning

# 🧹 UrbanStyle.ltd — Andmebaasi Auditi ja Puhastamise Raport 

## 📌 Ülevaade ja Nädala Küsimus
> **Kuidas muuta kaootilised andmed usaldusväärseks ilma midagi olulist kaotamata?**
> 
> Kuna SQL-is on käsud nagu `DELETE` ja `UPDATE` lõplikud, kasutasime riskide maandamiseks kaheastmelist lähenemist:
> 1. **Testkeskkonna kasutamine:** Kõik puhastustoimingud ja päringud käivitati spetsiaalses testtabelis (`sales_test`), et veenduda soovitud tulemustes ja vältida tegelike tootmisandmete ohtu seadmist või kaotamist.  
>    * 📸 [Test-tabelite vaade GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-2/test_tabelid.png)
> 2. **Analüüs enne muutmist:** Enne reaalsete muudatuste kinnitamist tehti põhjalik kontroll `SELECT` päringutega. Kasutati funktsioone `TRIM`, `INITCAP` ning kuupäevavorminguid, et näha tulemust ette ja tagada, et ükski oluline finants- või kliendikirje ei saaks kahjustada.

---

## 📸 Visuaalne kontroll ja tõendid

1. **Kõikide tabelite üldülevaade:** [Vaata pilti GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-2/K%C3%B5ikide%20tabelite%20dublikaadid.png)
2. **Tühjade väärtuste (`NULL`) kontroll:** [Vaata pilti GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-2/Null%20v%C3%A4%C3%A4rtuste%20%C3%BClevaade.png)
3. **Linnanimede ülevaade:** [Vaata pilti GitHubis](https://github.com/Nata376/daca-portfolio/blob/main/week-2/Linnanimede%20%C3%BClevaade.png)

---

## 📊 Muudetud tabelite kokkuvõte

### 1. Müügiandmete tabel (`sales_test`) — Audit vs Puhastuse tulemus

* **Ridade arv ja duplikaadid:**
  * **Algne ridade arv:** 15 234 rida.
  * **Duplikaatide eemaldamine:** Eemaldati **5 116 duplikaatset rida**.
  * **Lõplik ridade arv:** **10 118 rida**.

* **Käibe mõju:**
  * **Enne puhastamist:** **4 374 231.27 €** *(duplikaatide tõttu kunstlikult paisutatud)*.
  * **Pärast puhastamist:** **2 909 177.08 €**.
  * **Äriline mõju:** Duplikaatide eemaldamisega korrigeeriti finantsraporteid **1 465 054.19 €** võrra, mis taastas tegeliku käibepildi.

* **Kliendi ID-d ja külalisostud:**
  * **Analüüs:** Pärast duplikaatide eemaldamist jäi tabelisse **988 külalisostu** (tühja kliendi ID-ga tehingut).
  * **Puhastus:** Tühjad kliendi ID-d asendati koodiga **`-1`**.
  * **Äriline põhjus:** Need on registreerimata kasutajate sooritatud ostukorvid (*guest checkout*). Neid ei tohi kustutada, et mitte kaotada tegelikku müügitulu.

* **Andmekvaliteedi parandused:**
  * **Tuleviku kuupäevad:** Süsteemiveaga tekkinud tulevikukuupäevad asendati tehingu tegemise päeva kuupäevaga.
  * **Asukohad ja müügikanalid:** Kaetud on e-pood (`NULL`), Tallinn, Tartu ja Pärnu esindused.

---

### 2. Toodete tabel (`products_test`) — Audit ja puhastamise tulemused

* **Toodete koguarv:** **362 toodet** *(Muutusteta)*.

* **Hinnaklass ja terviklikkus:**
  * **Kallim toode:** **434,00 €**
  * **Odavaim toode:** **13,58 €**
  * **Hinna audit:** Puuduvad ehk `NULL` hinnad puuduvad täielikult, kõikidel toodetel on korrektne hind olemas.

* **Duplikaatide käsitlus:**
  * Audit tuvastas **12 korduva tootenimega duplikaati**.
  * **Puhastuse otsus:** Neid ridu **ei kustutatud**, et mitte lõhkuda seoseid müügiajalooga (`sales_test` tabeliga) ega tekitada orderite tabelis orbkirjeid.

* **Tekstiväljade standardiseerimine:**
  * Kategooriate nimetused ühtlustati ja muudeti visuaalselt korrektseks, seades esitähe suureks.
  * **Tooteliigid (5):** `Jalanõud`, `Lasteriided`, `Aksessuaarid`, `Naiste_riided`, `Meeste_riided`.

---

### 3. Klientide tabel (`customers_test`) — Audit vs Puhastuse tulemus

* **Klientide koguarv:** **3 150 klienti** *(Ridade arv säilitati täielikult)*.

* **E-mailide käsitlus ja duplikaadid:**
  * **Duplikaatsed e-mailid:** Tabelis tuvastati **129 duplikaatset e-maili**.
  * **Äriline otsus:** Duplikaatse e-mailiga ridu **ei kustutatud**. Kuna nendega on seotud erinevad nimed ja müügiajalugu, võiks kustutamine kaasa tuua reaalse müügistatistika kaotuse. Ühe e-maili taga võivad olla pereliikmed, sama ettevõtte era- ja äriklient või ühiskasutuses e-mail ning puudub alus eeldada, kumb kirje on "õige".
  * **Puuduvad e-mailid:** Tabelisse jäi alles **380 puuduvat/tühja e-maili** (`NULL`), mida ei saa ilma kliendi otsese sekkumiseta taastada.

* **Linnanimede standardiseerimine (`INITCAP` + `TRIM`):**
  * **Enne:** Linnade nimekiri oli korrastamata (54 erinevat ebaühtlast kirjaviisi, nt `tallinn`, `TALLINN`, `Tallinn`).
  * **Pärast:** Kirjaviisid ühtlustati, mille tulemusel jäi järele **12 korrektset linna**.
  * **Äriline mõju:** Nüüd on võimalik teha täpset regionaalset aruandlust, analüüsida müüke linnade kaupa ning seadistada turunduskampaaniaid konkreetsetele piirkondadele.

* **Kontaktandmete formaat:**
  * **Telefoninumbrid:** Formatiseering oli vaatlusel juba standardne ega vajanud muudatusi.

---

## 🔍 Ristvalideerimise märkused ja järeldused

* **Orbkirjete puudumine (0):** Kinnitab, et tehingute ja baastabelite (`customers`, `products`) vahelised seosed on täielikult terved.
* **Vaimtooted (12):** Tuvastatud 12 müümata toodet on otseselt seotud `products_test` tabelis leitud **12 duplikaatse tootenimega**. Kuna praegu puudub lisainfo (nt tootekoodide päritolu või laoseis), mille põhjal otsustada, milline kahest kirjest on õige, jäeti need teadlikult alles, et vältida andmete enneaegset kaotamist.
* **Vaimkliendid (592):** Tegemist on registreerunud kasutajatega, kes pole veel ostu sooritanud (normaalne nähtus e-kaubanduses, sobib turunduskampaaniate sihtimiseks).
* **Hinna ebakõlad (664):** Vajavad täiendavat analüüsi koos allahindluste ja kampaaniate registriga.

---

## 💡 Ärilised soovitused edaspidiseks

1. **Süsteemsed piirangud sisendväljadele (*Validation Rules*):**
   * E-poe registreerimisel ja kassas tuleks sisse viia automaatne linnanime ja e-maili formaadi kontroll (nt rippmenüü linna valikuks), et vältida trükivigu ja kümnete eri variantide tekkimist tulevikus.
2. **Duplikaatsete e-mailide ja klientide haldus:**
   * Soovitatav on ehitada e-poe taustasüsteemi loogika, mis küsib sama e-mailiga uue konto loomisel: *"Kas soovid olemasoleva kontoga sisse logida või luua eraldi äri-/erakliendi profiili?"*.
3. **Müügiandmete automaatne dubleerimise kaitse:**
   * Andmebaasi tasemel tuleks `sales` tabelile lisada unikaalsuse piirang (*UNIQUE constraint*) tehingu ID-le või ajatemplile, et süsteemitõrgete korral ei saaks sama müügitehing kaks korda andmebaasi salvestuda.
4. **Hindade sünkroniseerimine:**
   * Uurida 664 tuvastatud hinna ebakõla tekkepõhjuseid veendumaks, kas tegu on süsteemivea, kassasüsteemi ülekirjutamise või korrektsete kampaaniasoodustustega.

---

## 🔗 SQL päringud
Puhastamisel ja analüüsil kasutatud SQL päringutega saab tutvuda siin:
* [Wee 2_ SQL_cleaning_IT.sql](https://github.com/Nata376/daca-portfolio/blob/main/week-2/Wee%202_%20SQL_cleaning_IT.sql)
* [Week_2_SQL Cleaning_tables.sql](https://github.com/Nata376/daca-portfolio/blob/main/week-2/Week_2_SQL%20Cleaning_tables.sql)

---

## 👥 Meeskonna lingid
* 📁 **Minu osa (GitHub Repository):** [Natalia töö nädal 2](https://github.com/Kolju3/DACA-group/tree/main/week-2/individual/natalia)
* 👥 **Terve tiimi repositoorium:** [Group README.md](https://github.com/Kolju3/DACA-group/blob/main/week-2/group/README.md)

---

## 🚀 Kokkuvõte
Nädala jooksul teostatud andmete audit ja puhastus võimaldas korrigeerida finantsstatistikat **1,46 miljoni euro** võrra, viia linnade andmed turundus- ja regionaalanalüüsiks sobilikku kujule ning säilitada samal ajal 100% kõigist reaalsetest kliendi- ja müügikirjetest. Ilma orbkirjeteta andmebaas kinnitab, et relatsiooniline struktuur on hoitud tervena ning andmestik on valmis Power BI või Tableau tasemel edasiseks analüüsiks.