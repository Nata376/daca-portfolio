🔗 Nädal 3: SQL Joins — Vastused Turundusjuhile
📌 Lähteülesanne
Anna Mets (turundusjuht): "Mul on vaja teada, KES on meie parimad kliendid, MIDA nad ostavad ja KUST nad tulevad. Pelgalt ID-dest ei piisa — mul on vaja reaalset pilti järgmise kampaania jaoks!"

Lahendus: Kasutasime JOIN-lauseid, et ühendada sales_test, customers_test ja products_test tabelid üheks terviklikuks vaateks.

📊 Vastused Anna Küsimustele
1. KES on meie TOP klienti ja MIDA nad ostavad? (INNER JOIN)
Päring: Ühendasime sales + customers + products tabelid.

Tulemus: Tuvastasime suurima ostumahuga kliendid, nende regionaalse jaotuse ja ostueelistused.

Kõige väärtuslikum klient: TOP 10 analüüs näitab (📸 tõend GitHubis), et meie suurim klient on Tartu klient Tiina Pärn, kes on ostnud tooteid kokku uskumatu 26 000 € eest (sellest 10 940 € eest üksnes jalanõusid — 📸 tõend GitHubis).

Teised tippkliendid: Järgnevate TOP 20 klientide ostusummad jäävad kategooriate lõikes vahemikku 8 000 – 9 000 € (📸 tõend GitHubis).

Kõrge väärtusega kliendibaas: Süsteemis on kokku 762 klienti, kelle ostusumma ületab keskmise müügi taset (📸 tõend GitHubis).

Ostukorvi käitumine: Meie kliendid panevad korraga ostukorvi 1–5 toodet.

Tallinna müügimootor: Kõige rohkem oste on tehtud Tallinnas — 3 601 ostu kogusummas ligi 1 000 000 € (1 mln €) (📸 tõend GitHubis). Tallinnas on populaarseimad kategooriad meesteriided (792 müüki), jalanõud (744 müüki) ja naisteriided (710 müüki) — kõiki müüdud üle 700 korra.

Otsus Annale: Tippklientidele ja 762-le keskmisest enam ostvale kliendile tasub suunata personaalne VIP-lojaalsusprogrammi pakkumine. Tallinna turunduses tasub hoida fookuses riideid ja jalanõusid.

2. Kuidas toimib meie Lojaalsusprogramm? (Suur kasutamata potentsiaal!)
Päring: Rühmitasime kliendid ja nende ostusummad lojaalsustasemete kaupa.

Tulemus: Süsteemis on kasutusel 4 lojaalsustaset.

Liitunud kliendid: Umbkaudu 1 500 klienti on liitunud kolme aktiivse tasemega ning nemad on genereerinud umbes 1,5 mln € käivet (📸 tõend GitHubis).

⚠️ KRIITILINE POTENTSIAAL: Andmebaasis on üle 1 000 kliendi, kes on sooritanud oste 1 000 000 € (1 mln €) eest, kuid EI OLE lojaalsusprogrammiga liitunud!

Otsus Annale: Need 1000+ liitumata klienti on kõige lihtsamini püütav sihtrühm korduvostude suurendamiseks. Neile tuleb suunata otsene teavitus ja liitumisboonus.

3. KUI PALJU on raisatud potentsiaali ehk inaktiivseid kliente? (LEFT JOIN)
Päring: Otsisime kliendid, kellel puudub seos sales tabelis (WHERE sales.customer_id IS NULL).

Tulemus: 599 klienti on registreerunud, kuid pole teinud ühtegi ostu.

Vanim ostuta klient: Vanim süsteemi registreerunud klient ilma ühegi ostuta pärineb kuupäevast 13.02.2020 (📸 tõend GitHubis).

Regionaalne jaotus: Kõige rohkem inaktiivseid kliente on Tallinnas (231) ja kõige vähem Paides (11) (kus registreerimine pole üldse populaarne) (📸 tõend GitHubis).

Otsus Annale: Valmis sihtrühm uueks kampaaniaks — saata eelkõige Tallinna 231 inaktiivsele kasutajale e-mailiga esimese ostu ergutusboonus või sooduskood.

4. Millised tooted seisavad laos ilma müügita? (LEFT JOIN)
Päring: Otsisime tooted, mida pole kordagi ostetud (WHERE sales.product_id IS NULL).

Tulemus: 12 toodet on ilma ühegi müügita (📸 tõend GitHubis).

Märkus & Otsus Annale: Eelmisel nädalal tuvastasime, et need 12 toodet on ühtlasi tootenimede duplikaadid. Neid ei tasu kampaaniasse panna, vaid need tuleks IT-tiimi (Toomase) poolt andmebaasist täielikult kustutada, et vältida tootekataloogi saastamist.

🔗 Päringute Kood ja Hoidla Lingid
📜 Minu nädala SQL päringud: Vaata koodi repositorys

📁 Minu kaust tiimihoidlas: Natalia kaust (DACA-group)