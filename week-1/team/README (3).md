# 🚀 Nädal 1: UrbanStyle Müügi- ja Tooteandmete Audit

## 🎯 Projekti eesmärk (Äriküsimus)
Käesoleva analüüsi eesmärk oli kontrollida UrbanStyle.ltd müügi- ja tooteandmete usaldusväärsust. IT-juht Toomas Kask tuvastas potentsiaalsed andmekvaliteedi probleemid, mis vajasid põhjalikku auditeerimist enne, kui neid andmeid saab kasutada strateegilises ärianalüüsis ja otsustusprotsessides.

---

## 👥 Meeskond ja rollid
* **Helen (Roll A - Müügiandmete uurija):** Uuris tehingute mahtu, struktuuri ja võimalikke vigu summades ning kuupäevades.
* **Kalju (Roll B - Andmekvaliteedi ekspert):** Keskendus andmete "mustusele", tuvastades süsteemsed vead kirjapildis, tõstutundlikkuses ja tühikutes.
* **Natalia Krassilnikova (Roll C - Tooteandmed):** Analüüsis tooteandmebaasi sisu, kategooriaid ja hinnastatistikat.
* **Olga (Roll D - Müügikanalid ja asukohad):** Uuris müügikanaleid, kaupluste asukohti ja makseviise.

---

## 🔍 Peamised leiud ja avastused

### 1. Müügiandmete kvaliteet (Helen)
* **Maht:** Kokku 15 234 tehingut.
* **Puuduvad andmed:** 1 487 tehingul (~9,8%) puudub `customer_id`.
* **Kriitilised vead:** 305 negatiivse summaga tehingut (koguväärtus -88 632,61 EUR) ja 2 tuleviku kuupäevaga tehingut.

### 2. Andmete ebaühtlus ja "mustus" (Kalju)
Tuvastati tõsised probleemid asukohtade sisestamisel:
* **Kirjapilt:** Nt "Tallinn", "tallinn", "TALLINN" ja "Tallinn " loetakse süsteemis eraldi kirjeteks.
* **Tühikute vead:** Linna nimede lõppu jäänud tühikud loovad süsteemis dubleerivaid asukohti.
* **Mõju:** Takistab korrektse koondstatistika tegemist ilma eelneva andmepuhastuseta.

### 3. Tooteandmed (Natalia)
* **Maht:** 362 toodet viies põhikategoorias.
* **Kvaliteet:** Kõrge – ei tuvastatud puuduvaid hindu ega kategooriaid.
* **Hinnavahemik:** 13,53 EUR (vöö) kuni 434,00 EUR (sporditossud).

### 4. Müügikanalid ja asukohad (Olga)
* **Kanalid:** Online ja Pood.
* **Makseviisid:** Kaart, sularaha ja järelmaks.
* **Statistika:** 5 204 tehingul puudub asukoha info (viitab veebimüügi suurele osakaalule).

---

## 💡 Järeldused ja järgmised sammud
Andmestik on valdavalt kasutuskõlblik, kuid vajab enne analüüsi etappi korrastamist.

**Fookus 2. nädalaks:**
1. **Andmete normaliseerimine:** Asukohtade kirjapildi ühtlustamine ja tühikute eemaldamine.
2. **Negatiivsete tehingute uurimine:** Selgitada, kas tegemist on tagastustega või süsteemiveaga.
3. **Kliendiandmete analüüs:** Hinnata puuduvate kliendi ID-de mõju üldpildile.

---

## 🔗 Lingid tööriistadele
* [GitHub Repository](https://github.com/Kolju3/DACA-group)

