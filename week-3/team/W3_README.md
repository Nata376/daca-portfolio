# DACA Nädal 3 — UrbanStyle JOIN-analüüs

## Ülevaade

Nädal 3 eesmärk oli ühendada UrbanStyle’i killustatud andmetabelid SQL JOIN-ide abil, et vastata Anna Metsa ja Toomas Kase äriküsimustele.

Fookuses olid küsimused:

- kes on UrbanStyle’i parimad kliendid;
- millised registreerunud kliendid ei ole kunagi ostnud;
- millised tooted müüvad ja millised ei müü;
- milline on inventuuri seis;
- millised müügikanalid ja linnad töötavad kõige paremini;
- millised andmekvaliteedi riskid mõjutavad juhtimisotsuseid.

Analüüsi aluseks olid Nädal 2 käigus puhastatud andmed: **10 118 müügirida** ja **12 ühtlustatud linna**.

---

## Meeskond ja rollid

| Roll | Vastutaja | Teema | JOIN-loogika |
|---|---|---|---|
| Roll A | Natalia | Müük + kliendid | `INNER JOIN` |
| Roll B | Olga | Kliendid ilma ostudeta | `LEFT JOIN + IS NULL` |
| Roll C | Helen | Tooted + inventuur | `LEFT JOIN` |
| Roll D | Kalju | Kanalid + turundus | `INNER JOIN`, mitme tabeli JOIN |

---

## Kasutatud tabelid

Analüüsis kasutati järgmisi UrbanStyle’i andmetabeleid:

- `sales` — müügitehingud;
- `customers` — kliendiandmed;
- `products` — tootekataloog;
- `inventory` — laoseisud.

---

## Roll A — Müük + kliendid

### Eesmärk

Roll A eesmärk oli ühendada `sales` ja `customers` tabelid, et näha, millised kliendid on ostnud, kes on suurima kogumüügiga kliendid ning millistest linnadest ja lojaalsusgruppidest müük tuleb.

### Peamised leiud

| Näitaja | Tulemus |
|---|---:|
| Müügiridu `sales` tabelis | 10 118 |
| `INNER JOIN` tulemusse jõudnud müügiridu | 9 130 |
| JOIN-ist välja jäänud müügiridu | 988 |
| Suurima kogumüügiga klient | Tiina Pärn |
| Tiina Pärna kogumüük | 27 668.02 |
| Suurim müügilinn | Tallinn |
| Tallinna kogumüük | 1 006 252.88 |
| Suurim lojaalsusgrupp kogumüügi järgi | `NULL` |
| `NULL` lojaalsustasemega klientide kogumüük | 1 071 805.32 |
| Üle keskmise kogumüügiga kliente | 900 |

### Järeldus

Tallinn on UrbanStyle’i suurim müügipiirkond, kuid Tartu ja Pärnu kliendid on samuti äriliselt olulised. TOP-klientide seas on mitu kõrge väärtusega klienti väljaspool Tallinna.

Oluline andmekvaliteedi risk on see, et **988 müügirida ei seostu klienditabeliga**. See tähendab, et kliendipõhine analüüs ei kata kogu müüki. Lisaks on suurima kogumüügiga lojaalsusgrupp `NULL`, mis viitab võimalikule lojaalsusandmete puudulikkusele või süsteemidevahelisele katkestusele.

### Soovitus

- **Toomasele:** uurida, miks 988 müügirida ei leia vastet `customers` tabelist.
- **Annale:** mitte teha lojaalsuskampaaniaid ainult olemasoleva `loyalty_tier` jaotuse põhjal, sest suur osa väärtuslikust kliendibaasist võib olla märkimata.

---

## Roll B — Kliendid ilma ostudeta

### Eesmärk

Roll B eesmärk oli tuvastada registreerunud kliendid, kellel ei ole ühtegi müügitehingut. Selleks kasutati `customers LEFT JOIN sales` loogikat ja filtreeriti read, kus müügitabeli vaste puudub.

### Peamised leiud

| Näitaja | Tulemus |
|---|---:|
| Passiivseid registreerunud kliente | 599 |
| Aktiivseid kliente | 2 551 |
| Passiivsete osakaal | ligikaudu 1/5 registreerunutest |
| Suurim passiivsete klientide linn | Tallinn |
| Tallinna passiivseid kliente | 231 |
| Tartu passiivseid kliente | 133 |
| Pärnu passiivseid kliente | 78 |
| Muud linnad kokku | 157 |

### Järeldus

UrbanStyle’il on märkimisväärne arv registreerunud kliente, kes ei ole veel ostuni jõudnud. Need kliendid ei ole külm sihtrühm — nad on juba registreerunud ja seega potentsiaalselt odavamini aktiveeritavad kui täiesti uued kliendid.

Aktiivsete ja passiivsete klientide vahe viitab võimalikule konversiooniprobleemile: ostuteekond võib katkeda hinna, tarne, sortimendi, usalduse või kasutajakogemuse tõttu.

### Soovitus

- **Annale:** käivitada esmaostu kampaania passiivsetele klientidele, eriti Tallinnas ja Tartus.
- **Meeskonnale:** luua tervitus-workflow, mis sisaldab personaalset sõnumit, esimese ostu stiimulit ja järelmõõdikut 7 ning 30 päeva lõikes.

---

## Roll C — Tooted + inventuur

### Eesmärk

Roll C eesmärk oli siduda `products`, `sales` ja `inventory` tabelid, et leida müümata tooted, tugevad kategooriad, inventuuri puudujäägid ja võimalik ülevaru.

### Peamised leiud

| Näitaja | Tulemus |
|---|---:|
| Müümata tooteid | 12 |
| Inventuuri ridu kokku | 1 412 |
| `TELLI JUURDE` ridu | 221 |
| Negatiivse laoseisuga ridu | 10 |
| Inventuurivasteta ridu | 12 |
| Võimaliku ülevaru ridu | 730 |
| Vähemalt 10x üle tellimispunkti | 214 |
| Vähemalt 100x üle tellimispunkti | 31 |
| Suurim ülevaru kordaja | 628.60x |

### Müügitulemused kategooriate kaupa

| Kategooria | Tooteid | Müüke | Kogumüük |
|---|---:|---:|---:|
| jalanõusid | 73 | 2 031 | 774 034.75 |
| meeste_riided | 82 | 2 266 | 749 798.72 |
| naiste_riided | 70 | 2 022 | 686 464.24 |
| aksessuaarid | 67 | 1 772 | 393 035.82 |
| laste_riided | 70 | 2 027 | 305 844.45 |

### Järeldus

Inventuuriprobleem ei ole ainult puudujääk. Analüüs näitas kahte vastassuunalist riski:

1. **221 rida vajab juurde tellimist**, mis võib tähendada kaotatud müügivõimalust.
2. **730 rida viitab võimalikule ülevarule**, mis võib siduda kapitali ja laopinda.

Lisaks viitavad 10 negatiivse laoseisuga rida ja 12 inventuurivasteta rida andmekvaliteedi probleemidele.

### Soovitus

- **Toomasele:** jagada inventuuri kontroll neljaks töövooks:
  - andmekvaliteet: negatiivsed laoseisud ja inventuurivasteta tooted;
  - puudujääk: `TELLI JUURDE` read;
  - ülevaru: vähemalt 3x, 10x ja 100x üle tellimispunkti olevad read;
  - sortiment: müümata tooted ja võimalikud fantoomtooted.
- **Annale:** testida 12 müümata toodet kampaanias enne sortimendist eemaldamist.

---

## Roll D — Kanalid + turundus

### Eesmärk

Roll D eesmärk oli analüüsida müügikanaleid, linnu ja kategooriaid mitme tabeli JOIN-i abil. Fookuses oli küsimus, kas online-kanal ja füüsilised poed käituvad erinevalt ning kuidas kasutada kanalite infot turundusotsustes.

### Peamised leiud

| Näitaja | Tulemus |
|---|---:|
| Online-kanali käibe osakaal | 34.5% |
| Online-kanali käive | ligikaudu 1.0 mln |
| Tallinna esinduspoe käive | ligikaudu 1.08 mln |
| Online keskmine ost | 289.20 |
| Poodide keskmine ost | 285.05 |
| Kolme põhikategooria osakaal kogukäibes | 75.9% |

### Järeldus

Online-kanal ei ole kõrvalkanal, vaid üks UrbanStyle’i strateegilisi müügisambaid. Online’i käive on peaaegu samal tasemel kui Tallinna esinduspoe käive ning keskmine ost on online’is veidi kõrgem kui poodides.

Kanalite ja linnade analüüs näitab ka seda, et kliendid ei osta ainult oma elukoha füüsilises poes. Online-andmed võivad aidata hinnata uute linnade potentsiaali enne füüsilise poe avamist.

### Soovitus

- **Annale:** käsitleda online-kanalit eraldi strateegilise müügikanalina, mitte ainult poe müügi lisana.
- **Juhtkonnale:** kasutada online-aktiivsust uute pop-up poodide või tulevaste kaupluste asukoha eeltestimiseks.

---

## Koondjäreldused

### 1. Müük on tugevalt kontsentreeritud, kuid mitte ainult Tallinnasse

Tallinn juhib kogukäivet, kuid Tartu ja Pärnu annavad samuti olulise osa kõrge väärtusega klientidest. Kampaaniate planeerimisel ei tohiks regionaalset fookust kitsendada ainult Tallinnale.

### 2. Kliendibaasis on suur aktiveerimata potentsiaal

599 registreeritud klienti ei ole ostuni jõudnud. See on üks selgemaid turunduslikke võimalusi, sest need kliendid on juba süsteemis olemas.

### 3. Lojaalsusandmed vajavad auditit

Suurima kogumüügiga lojaalsusgrupp on `NULL`. See võib tähendada, et väärtuslikud kliendid jäävad lojaalsuskampaaniatest välja või et süsteemide vahel ei liigu lojaalsusinfo korrektselt.

### 4. Varude juhtimine vajab kahesuunalist kontrolli

UrbanStyle’il on korraga nii puudujäägi kui ülevaru probleem. Enne automaatseid tellimisotsuseid tuleb eristada, kas konkreetne rida viitab tegelikule nõudlusele, ülevarule või andmeveale.

### 5. Online-kanal on strateegiline kasvukanal

Online moodustab olulise osa käibest ja keskmine ost on vähemalt võrreldav poeostuga. Seda tuleb arvestada nii turunduseelarves kui ka laienemisotsustes.

---

## Suurim üllatus

Suurim üllatus oli see, et kõige suurema kogumüügiga lojaalsusgrupp on `NULL`. See tähendab, et UrbanStyle’i väärtuslik kliendisegment võib olla lojaalsusprogrammi vaates nähtamatu.

Teine oluline üllatus oli inventuuri ülevaru ulatus: 730 võimalikku ülevaru rida ning 31 rida, kus laoseis on vähemalt 100 korda üle tellimispunkti.

---

## Strateegilised soovitused juhtkonnale

### 1. Andmekvaliteedi audit

Kontrollida tuleb:

- 988 müügirida, mis ei seostu klienditabeliga;
- `NULL` lojaalsustasemega kõrge müügiväärtusega kliendid;
- 10 negatiivse laoseisuga inventuuririda;
- 12 inventuurivasteta toodet.

### 2. Passiivsete klientide aktiveerimine

Käivitada esmaostu kampaania 599 passiivsele kliendile. Mõõta kampaania mõju 7 ja 30 päeva lõikes.

### 3. Varude ümberjuhtimine

Peatada või käsitsi üle kontrollida automaatsed tellimused toodetel, kus laoseis on väga kõrge võrreldes tellimispunktiga. Vabanev kapital suunata toodetele, mis on tugeva müügiga ja `TELLI JUURDE` staatuses.

### 4. Surnud sortimendi testimine

12 müümata toodet ei tohiks automaatselt kustutada. Neid tuleks testida kampaanias või hinnata koos müügikiiruse, hooajalisuse ja laoseisuga.

### 5. Online-kanali tugevdamine

Online-kanalit tuleb käsitleda eraldi strateegilise kanalina. Seda saab kasutada nii kampaaniate optimeerimiseks kui ka uute linnade nõudluse eeltestimiseks.

---

## Puuduvad andmed ja piirangud

Analüüsi tõlgendamisel tuleb arvestada järgmiste piirangutega:

- Puudub info kampaaniate maksumuse kohta, mistõttu ei saa hinnata ROAS-i.
- Puudub tagastuste info, mis võib mõjutada toote- ja kategooriakasumlikkust.
- Ei ole teada, miks 988 müügirida ei leia klienditabelist vastet.
- Ei ole teada, miks suurima müügiga lojaalsusgrupp on `NULL`.
- Müümata toode ei ole automaatselt vale toode — see võib olla uus, hooajaline või halvasti nähtav toode.
- Negatiivsete laoseisude algpõhjus vajab süsteemset kontrolli.

---

## Failid

- [W3 Presentatsioon](https://github.com/Kolju3/DACA-group/blob/main/week-3/group/UrbanStyle_Op_JOIN-anal%C3%BC%C3%BCs.pptx)
- [Roll A](https://github.com/Kolju3/DACA-group/tree/main/week-2/individual/natalia)
- [Roll B](https://github.com/Kolju3/DACA-group/tree/main/week-2/individual/olga)
- [Roll C](https://github.com/Kolju3/DACA-group/tree/main/week-2/individual/helen)
- [Roll D](https://github.com/Kolju3/DACA-group/tree/main/week-2/individual/kalju)

---

## Kasutatud SQL-tehnikad

- `INNER JOIN`
- `LEFT JOIN`
- `LEFT JOIN + WHERE ... IS NULL`
- mitme tabeli JOIN
- `GROUP BY`
- `ORDER BY`
- `COUNT`
- `SUM`
- `AVG`
- `COUNT(DISTINCT ...)`
- `CASE WHEN`
- `HAVING`

---

## Kokkuvõte

Nädal 3 JOIN-analüüs näitas, et UrbanStyle’i andmetes on olemas oluline äriline väärtus, kuid see väärtus avaneb alles siis, kui müügi-, kliendi-, toote- ja inventuuriandmed omavahel seostada.

Kõige olulisemad juhtimiskohad on:

1. kliendiandmete seostamise parandamine;
2. lojaalsusprogrammi andmete audit;
3. passiivsete klientide aktiveerimine;
4. varude puudujäägi ja ülevaru eristamine;
5. online-kanali käsitlemine strateegilise kasvukanalina.

Analüüsi põhjal ei ole peamine küsimus ainult „mis müüb?“, vaid ka „millised andmeseosed puuduvad ja milliseid otsuseid need puuduvad seosed võivad moonutada?“

