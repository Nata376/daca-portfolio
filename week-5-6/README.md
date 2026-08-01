📊 DACA Nädal 5: Visualiseerimise disain — Aruanne

👤 OSA 1: Iseseisev töö
"Halb dashboard on hullem kui tabel, sest ta NÄIB, nagu annaks vastuseid — aga tegelikult segab."

🎯 Ülevaade ja eesmärk
Selle nädala eesmärk oli lahendada Kristi ja Anna püstitatud ülesanne: kuidas muuta 1247 müügirida üheks selgeks ekraaniks, mis veenab investoreid 30 sekundiga.

🛠️ Planeerimise etapid (Samm-sammuline teekond)
Enne Power BI-s ehitama asumist läbisin järgmised disaini- ja planeerimisetapid:

Äriküsimuste kaardistamine (Sisu fokuseerimine)

Diagrammitüüpide valik (Storytelling)

Valisin igale küsimusele sobiliku structures: ajatrendile joondiagramm, edetabelile horisontaalne tulpdiagramm ja osakaaludele sõõrikdiagramm.

Paberil kavandamine (Wireframing & Z-muster)

Visandasin paberil töölaua paigutuse, arvestades inimsilma liikumist (Z-muster).

Kujundasin töölaua vastavalt Urbanstyle värvipaletile.

Planeerisin visuaalse müra vähendamise: eemaldasin liigsed komakohad ja ruudustikujooned ning ümardasin numbrid tuhandeteni (K ja M), et tagada kiire loetavus.

Teostus ja interaktiivsuse häälestus (Power BI)

Ühendasin andmebaasi (Supabase), kohandasin teema (Theme), ehitasin visuaalid ning häälestasin ristelemendid (Cross-filtering) ja filtrid.

💡 Äriküsimused ja visuaalsed lahendused
1. Diagrammitüüpide valik
Müügitrendid kuude kaupa (Joondiagramm)

Äriküsimus: Kas me kasvame?

Lahendus: Näitab selgelt käibe kõikumist ja hooajalisust (miinimum Märts €202K, tipp Detsember €305K).

Top toodet (Horisontaalne tulpdiagramm)

Äriküsimus: Mis tooted müüvad?

Lahendus: TOP 10 toodet on parema loetavuse huvides järjestatud pikemate nimedega horisontaalselt (Õhuline sünteetiline sporditoode €27K, Trendikas goretex oxfordid €23K jne).

Müügikohtade osakaal (Sõõrikdiagramm)

Äriküsimus: Kust tulevad kliendid?

Lahendus: Näitab täpseid proportsioone — Tallinn (€1.09M / 37.54%) ja Online (€1.01M / 34.61%) moodustavad kahe peale üle 72% kogu käibest.

2. Filtrid ja interaktiivsus
Kuupäevariba (Slicer slider): Laseb kasutajal suumida konkreetsesse ajavahemikku.

Müügikoha filter (Dropdown menüü): Võimaldab isoleerida konkreetse kaupluse või e-poe näitajad.

Ristfiltreerimine (Cross-filtering): Klikkides sõõrikdiagrammil nt "Tallinn" või "Online", kohanduvad joondiagramm ja TOP-tooted automaatselt vastava asukoha andmetega.

👥 OSA 2: Grupitöö rollid ja tulemused

🏢 Roll A: CEO Dashboard (Kristi vaade — Tulemused 2023 vs 2024)
Käive (2024): 1.47M € (+19.1% vs 2023: 1.23M €)

Klientide arv (2024): 2114 (+20.4% vs 2023: 1756)

Trendi analüüs: 2024. aasta (tume sinine joon) püsib läbi terve aasta stabiilselt kõrgemal kui 2023. aasta (rohekas joon). Tipp saavutatakse detsembris (171K €).

Põhisõnum: "Müügid kasvasid aastaga 19% ja kliendid 20%. Ettevõtte kasv on stabiilne ja kantud e-poe kiirest arengust."

📢 Roll B: Marketing Dashboard (Anna vaade — Kanalid ja kliendid)
Kliendid kokku: 2 552 ostnud | 599 ostuta registreerunut ("vaimklienti")

Käibejaotus: Kaupluste võrk 1.90M € (65%) vs Online 1.01M € (35%)

Linnade edetabel: Tallinn juhtpositsioonil (1.79K klienti), järgnevad Tartu (1.12K) ja Pärnu (0.75K).

Põhisõnum: "Füüsilised poed toovad 65% käibest, kuid e-pood on efektiivseim kanal. Turunduse teravik tuleb suunata 599 registreerunud kliendi konverteerimisele."

📦 Roll C: Operations Dashboard (Liisi vaade — Inventuur ja laoseis)
Lao maht kokku: 377K ühikut

Lao ostuväärtus: 44.24M € | Lao müügiväärtus: 67.54M €

Struktuur: Suurim laoseis on pealaos meeste riiete (>101K ühikut) ja jalanõude (~86K ühikut) kategooriates.

Põhisõnum: "2,9M € käibe juures seisab laos kinni 44,24M € ostuväärtuses kapitali. Vaja on laovarusid optimeerida ja liigsed jäägid realiseerida."

💼 Roll D: Investor Dashboard (Koondvaade Kristi + Investorid)
Kogutulu: 2.91M € | Kliendid: 2552 | Keskmine ostukorv (AOV): 288 €

Koondsüntees: Müügikasv (+19.1%) on kantud peamiselt uute klientide lisandumisest (+20.4%), samal ajal kui ostukorvi suurus on püsivalt stabiilne (~288 €).

Olulisim tähelepanek: Tallinn ja Online moodustavad käibest üle 72%. Detsember on selge peakuu, milleks tuleb tarneahel varakult valmis seada.# Nädal 5-6: Visualiseerimine

🤖 AI Kasutamine
AI-d kasutati SQL päringute (DATE_TRUNC, GROUP BY) ja DAX mõõdikute optimeerimiseks ning disainipõhimõtete kontrollimiseks vastavalt Knaflic mudelile.
