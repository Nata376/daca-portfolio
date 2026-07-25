🔗 Nädal 3: SQL Joins — Vastused Turundusjuhile
📌 Lähteülesanne
Anna Mets (turundusjuht): "Mul on vaja teada, KES on meie parimad kliendid, MIDA nad ostavad ja KUST nad tulevad. Pelgalt ID-dest ei piisa — mul on vaja reaalset pilti järgmise kampaania jaoks!"

Lahendus: Kasutasime JOIN-lauseid, et ühendada sales_test, customers_test ja products_test tabelid üheks terviklikuks vaateks.

📊 Vastused Anna Küsimustele
1. KES on meie TOP 20 klienti ja MIDA nad ostavad? (INNER JOIN)
Päring: Ühendasime sales + customers + products tabelid.

Tulemus: Tuvastasime suurima ostumahuga kliendid ja nende ostueelistused.

Kõige väärtuslikum klient: Tartu klient Tiina Pärn, kes on ostnud jalanõusid koguni 10 940 € eest.

Teised tippkliendid: Järgnevate TOP klientide ostusummad jäävad vahemikku 8 000 – 9 000 €.

Ostukorvi käitumine: Meie kliendid panevad korraga ostukorvi 1–5 toodet.

Tallinna müügihitid: Tallinnas on kõige populaarsemad kategooriad meesteriided (792 müüki), jalanõud (744 müüki) ja naisteriided (710 müüki) — kõiki neid on müüdud igaüht üle 700 korra.

📸 Tõend: TOP 20 klienti tootekategooriatega (GitHub screenshot)

Otsus Annale: Nendele tippklientidele tasub suunata personaalne VIP-lojaalsusprogrammi pakkumine ja eksklusiivsed eelissoodustused. Tallinna turunduses tasub eelkõige fookuses hoida riideid ja jalanõusid.

2. KUI PALJU on raisatud potentsiaali ehk inaktiivseid kliente? (LEFT JOIN)
Päring: Otsisime kliendid, kellel puudub seos sales tabelis (WHERE sales.customer_id IS NULL).

Tulemus: 599 klienti on registreerunud, kuid pole teinud ühtegi ostu.

Vanim ostuta klient: Vanim süsteemi registreerunud klient ilma ühegi ostuta pärineb kuupäevast 13.02.2020.

Regionaalne jaotus: Kõige rohkem inaktiivseid kliente on Tallinnas (231) ja kõige vähem Paides (11) (kus registreerimine pole üldse populaarne).

📸 Tõendid:

Kadunud kliendid linnade kaupa

Kadunud kliendid koondvaade

Otsus Annale: Valmis sihtrühm uueks kampaaniaks — saata eelkõige Tallinna inaktiivsetele kasutajatele e-mailiga esimese ostu ergutusboonus või sooduskood.

3. Millised tooted seisavad laos ilma müügita? (LEFT JOIN)
Päring: Otsisime tooted, mida pole kordagi ostetud (WHERE sales.product_id IS NULL).

Tulemus: 12 toodet on ilma ühegi müügita.

📸 Tõend: Müümata tooted (GitHub screenshot)

Märkus & Otsus Annale: Eelmisel nädalal tuvastasime, et need 12 toodet on ühtlasi tootenimede duplikaadid. Neid ei tasu kampaaniasse panna, vaid need tuleks IT-tiimi (Toomase) poolt andmebaasist täielikult kustutada, et vältida tootekataloogi saastamist.
