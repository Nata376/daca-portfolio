# 🔗 Nädal 3: SQL Joins — Vastused Turundusjuhile ja Logistikale

## 📌 Lähteülesanne
> **Anna Mets (turundusjuht):** *"Mul on vaja teada, KES on meie parimad kliendid, MIDA nad ostavad ja KUST nad tulevad. Pelgalt ID-dest ei piisa — mul on vaja reaalset pilti järgmise kampaania ja laojuhtimise jaoks!"*
> 
> **Lahendus:** Kasutasime `JOIN`-lauseid, et ühendada `sales_test`, `customers_test` ja `products_test` tabelid üheks terviklikuks vaateks.

---

## 📊 Vastused Anna Küsimustele, Müügikanalid ja Logistikaanalüüs

### 1. KES on meie TOP klienti ja MIDA nad ostavad? (`INNER JOIN`)
* **Päring:** Ühendasime `sales` + `customers` + `products` tabelid.
* **Tulemus:** Tuvastasime suurima ostumahuga kliendid, nende regionaalse jaotuse ja ostueelistused.
  * **Kõige väärtuslikum klient:** TOP 10 analüüs näitab ([📸 tõend GitHubis](./Screenshotid/TOP%2010%20klienti%20m%C3%BC%C3%BCkide%20j%C3%A4rgi.png)), et meie suurim klient on Tartu klient **Tiina Pärn**, kes on ostnud tooteid kokku uskumatu **26 000 €** eest (sellest 10 940 € eest üksnes jalanõusid — [📸 tõend GitHubis](./Screenshotid/TOP%2020%20klienti%20tootekategooriatega.png)).
  * **Teised tippkliendid:** Järgnevate TOP 20 klientide ostusummad jäävad kategooriate lõikes vahemikku **8 000 – 9 000 €** ([📸 tõend GitHubis](./Screenshotid/TOP%2020%20klienti%20tootekategooriatega.png)).
  * **Kõrge väärtusega kliendibaas:** Süsteemis on kokku **762 klienti**, kelle ostusumma ületab keskmise müügi taset ([📸 tõend GitHubis](./Screenshotid/Kliendid%20kelle%20ostud%20on%20%C3%BCle%20keskmise.png)).
  * **Ostukorvi käitumine:** Meie kliendid panevad korraga ostukorvi **1–5 toodet**.
  * **Tallinna müügimootor:** Kõige rohkem oste on tehtud Tallinnas — **3 601 ostu** kogusummas ligi **1 000 000 € (1 mln €)** ([📸 tõend GitHubis](./Screenshotid/M%C3%BC%C3%BCk%20linnade%20kaupa.png)). Tallinnas on populaarseimad kategooriad **meesteriided** (792 müüki), **jalanõud** (744 müüki) ja **naisteriided** (710 müüki) — kõiki müüdud üle 700 korra.
* **Otsus Annale:** Tippklientidele ja 762-le keskmisest enam ostvale kliendile tasub suunata personaalne VIP-lojaalsusprogrammi pakkumine. Tallinna turunduses tasub hoida fookuses riideid ja jalanõusid.

---

### 2. Müügikanalid linnade lõikes ja Turunduseelarve Fookus
* **Päring:** Rühmitasime müügitehingud linnade ja müügikanalite (POS ehk kauplus vs e-pood) kaupa ([📸 tõend GitHubis](./Screenshotid/M%C3%BC%C3%BCgikanalid%20linnade%20l%C3%B5ikes.png)).
* **Tulemused:**
  * **Peamine müügivedur:** Kõige rohkem ostetakse **Tallinna füüsilisest kauplusest (POS)** — kokku **910 ostu** käibega **670 000 €**.
  * **Kõige nõrgem kanal:** Kõige vähem ostavad **Paide kliendid e-poest** — kokku vaid **32 ostu** käibega **135 000 €**.
* **💡 Soovitus Turunduseelarve Suunamiseks (Annale):**
  * **Maksimiseeri Tallinna POS (Suurim ROI):** Suuna **60–70% turunduseelarvest** Tallinna piirkonna kohalikku ja digitaalsesse reklaami (geotargeting), et tuua kohapealsesse kauplusesse veelgi rohkem füüsilist jalajälge.
  * **E-poe ja väikelinnade (Paide) ergutus:** E-poe turundusse suunata sihitud pakkumisi eeskätt piirkondadesse, kus füüsilist kauplust pole või kus digiostude sagedus on madal (tasuta tarne kampaaniad, e-poe tervitusboonused).

---

### 3. Kuidas toimib meie Lojaalsusprogramm? (Suur kasutamata potentsiaal!)
* **Päring:** Rühmitasime kliendid ja nende ostusummad lojaalsustasemete kaupa.
* **Tulemus:** Süsteemis on kasutusel **4 lojaalsustaset**.
  * **Liitunud kliendid:** Umbkaudu **1 500 klienti** on liitunud kolme aktiivse tasemega ning nemad on genereerinud umbes **1,5 mln €** käivet ([📸 tõend GitHubis](./Screenshotid/M%C3%BC%C3%BCk%20lojaalsusprogrammi%20kaupa%20.png)).
  * ⚠️ **KRIITILINE POTENTSIAAL:** Andmebaasis on **üle 1 000 kliendi**, kes on sooritanud oste **1 000 000 € (1 mln €)** eest, kuid **EI OLE lojaalsusprogrammiga liitunud**!
* **Otsus Annale:** Need 1000+ liitumata klienti on kõige lihtsamini püütav sihtrühm korduvostude suurendamiseks. Neile tuleb suunata otsene teavitus ja liitumisboonus.

---

### 4. KUI PALJU on raisatud potentsiaali ehk inaktiivseid kliente? (`LEFT JOIN`)
* **Päring:** Otsisime kliendid, kellel puudub seos `sales` tabelis (`WHERE sales.customer_id IS NULL`).
* **Tulemus:** **599 klienti** on registreerunud, kuid pole teinud ühtegi ostu.
  * **Registreerimiste tipphetk (1. jaanuar 2025):** Kõige rohkem ostuta kliente (**53 inimest**) registreerus üheainsa päevaga — **01.01.2025** ([📸 tõend GitHubis](./Screenshotid/Kadunud%20kliendid%20kuup%C3%A4eva%20j%C3%A4rgi.png)).
  * **Vanim ostuta klient:** Vanim süsteemi registreerunud klient ilma ühegi ostuta pärineb kuupäevast **13.02.2020** ([📸 tõend GitHubis](./Screenshotid/Kadunud%20kliendid%20linnade%20kaupa.png)).
  * **Regionaalne jaotus:** Kõige rohkem inaktiivseid kliente on **Tallinnas (231)** ja kõige vähem **Paides (11)** (kus registreerimine pole üldse populaarne) ([📸 tõend GitHubis](./Screenshotid/Kadunud%20kliendid%20koondvaade.png)).
* **Otsus Annale:** 
  * **Analüüsida 01.01.2025 kampaania ebaõnnestumist:** Kontrollida turundusajalugu ja vaadata, milline kampaania või uue aasta pakkumine tõi sel päeval 53 kasutajat kontot looma, kuid miks ostuprotsess katkes (kas sooduskood ei töötanud, tarne oli liiga kallis vms).
  * **Taasaktiveerimine:** Saata eelkõige Tallinna 231 inaktiivsele kasutajale e-mailiga esimese ostu ergutusboonus või sooduskood.

---

### 5. Millised tooted seisavad laos ilma müügita? (`LEFT JOIN`)
* **Päring:** Otsisime tooted, mida pole kordagi ostetud (`WHERE sales.product_id IS NULL`).
* **Tulemus:** **12 toodet** on ilma ühegi müügita ([📸 tõend GitHubis](./Screenshotid/M%C3%BC%C3%BCgita%20tooted.png)).
* **Märkus & Otsus Annale:** Eelmisel nädalal tuvastasime, et need 12 toodet on ühtlasi tootenimede duplikaadid. Neid ei tasu kampaaniasse panna, vaid need tuleks IT-tiimi (Toomase) poolt andmebaasist täielikult kustutada, et vältida tootekataloogi saastamist.

---

### 6. Laoseisud ja Logistika Ohumärgid (KRIITILINE LEID!)
* **Päring:** Analüüsisime laoseise asukohtade ja toodete kaupa.
* **Tulemused:**
  * Meil on kasutusel **4 ladu** ning igaühes neist asub täpselt **350 erinevat toodet** ([📸 tõend GitHubis](./Screenshotid/Tooteid%20kokku%20asukoha%20p%C3%B5hiselt.png)).
  * 🚨 **ÜLEMÜÜK JA KRIITILINE TILLIMISVAJADUS:** Mõned tooted on laos tegelikult **ülemüüdud (laoseis läinud miinusesse või kriitilisele piirile)** ning vajavad viivitamatut reageerimist ja juurdetellimist, et vältida klientide tellimuste tühistamist ([📸 tõend GitHubis](./Screenshotid/Tooted%20mis%20on%20laos%20ja%20vaja%20juurde%20tellida.png)).
* **Otsus Logistikale:** Algatada koheselt kiirtellimus kriitiliste toodete täiendamiseks ning kontrollida müügisüsteemi laohaldusliidest, et vältida toodete müümist miinusesse.

---

## 🔗 Päringute Kood ja Hoidla Lingid

* 📜 **Minu nädala SQL päringud ja failid:** [Vaata minu portfolio week-3 kausta (GitHub)](https://github.com/Nata376/daca-portfolio/tree/main/week-3)
* 📁 **Minu kaust tiimihoidlas:** [Natalia kaust (DACA-group)](https://github.com/Kolju3/DACA-group/tree/main/week-3/individual/natalia)
