# Korpuse töötlemise programmid

Hoiatus! Skript tavaliselt võtab sisendi mingist failist või kataloogist ja kirjutab kuskile; korpuse töötlemise etappidel tekivad uued failid ja kataloogid; 
aja jooksul tekib korpuse töötlemisest parem arusaamine ja siis lisanduvad uued töötlemissammud varasemate sammude vahele, ja sellega seoses omakorda uued (vahe)failid ja (vahe)kataloogid...
Teiste sõnadega, skriptide sisend- ja väljundfailide nimed võivad kirjeldustes ja skripti enda tekstis üksteisest erineda, kuigi sellist segadust on püütud vältida.

## Tänapäevase sõnavara muundur

Tänapäevase sõnavara muundur mrflex.hfst on kasutusel sõnade teisendamise mõistlikkuse kontrollimisel.
Selle saaks teha lähtefailidest, mis on siin: https://github.com/giellalt/lang-est-x-utee
Seejuures sõnavara on sama, mis vabamorfi (https://github.com/Filosoft/vabamorf) spelleri sõnavara (sest vabamorfi leksikon on giellalt-lehele kopeeritud).


## AK algteksti parandamine

Parandamise skriptid on oma töö teinud ja neid pole vaja uuesti käivitada.
See tähendab, et neist on saanud arhiiv.

### Sisestusvead

    #### Sammud

   1. Tekita alg_tokyo-failidest tollaste sõnavormide sagedusloend 

       Käivita `./uuri_asutava_sonavara.sh`
        
       Tulemus: `../sonavara/asutava_soned.mitu` kujul *mitu sõnavorm*
       
       Sõnavara suurus on 85 000 sõnavormi.
       
   2. Leia üks kord esinevad sõnad, mis erinevad rohkem esinevatest ainult tõenäolise kirjavea poolest; ilmselt nad ongi vead. 
   
       Käivita `./leia_sisestusvead.sh`
        
       Tulemus: `../sonavara/viga_korras.tab` kujul *vigane@korras*

   3. Asenda vigased sõnad õigetega.

       Käivita `./paranda_sisestusvead.sh`
       
       Lähtekataloog: `alg_tokyo`

       Sihtkataloog: `tokyo`

### Poolitusvead

Käivita `paranda_poolitusvead.sh` 

Leiab ja parandab kriipsuga seotud vead: kui pärast sidekriipsu on jäänud tühik panemata, nt. *põhi-ja lisapalga* või on poolitusmärk jäänud eemaldamata, nt *wastu-tusele*.

Eeldab, et on olemas teisendusi ja tänapäevast sõnavara kombineeriv lõplik muundur, vt `./teisenda_sonavara_nyydseks1.sh`

Lähtekataloog: `tokyo`

Sihtkataloog: `uus_tokyo`; sealt tuleb failid käsitsi kopeerida `tokyo`-sse vanade asemele

## AK sõnavormide kaasajastamine

Käivita `./teisenda_ak_nyydseks.sh`

Asendab AK korpuse tekstides tolleaegsed sõnavormid tänapäevastega, jättes kõik muu (märgenduse, paigutuse) endiseks.

Lähtekataloog: `tokyo`

Sihtkataloog: `tokyo_nyydne`

Meetod: leia igale korpuse sõnavormile selle tänapäevane vaste (s.t. tegele korpuse sõnavaraga) ja kui see on tehtud, siis kasuta leitud sõnapaare, et asendada tekstis tollased sõnad nüüdsetega. Korpuse sõnad, millele tänapäevast varianti ei leita, tuleb jätta endiseks: nimed, lühendid.

### Sammud

1. Tee tokyo-failidest sõnavormide tabel kujul: *tollane nyydne*

    Käivita `./teisenda_sonavara_nyydseks.sh`

    #### Sammud

   1. Tekita tokyo-failidest tollaste sõnavormide sagedusloend 

       Käivita `./uuri_asutava_sonavara.sh`
        
       Tulemus: `../sonavara/asutava_soned.mitu` kujul *mitu sõnavorm*
       
       Sõnavara suurus on 85 000 sõnavormi.

   2. 1. Tükelda mõned sõnavormid kaheks (nt. *kõigeõigem*), sest need kirjutatakse tänapäeval lahku.

      2. Teisenda sõnavormid tänapäevasteks: teisenda ja kontrolli (spelleri) sõnastikuga, kas saadud sõna on analüüsitav kui kaasaegne. Teisendused ja sõnastik on kokku pandud lõplikuks muunduriks.  

       Igal analüüsivariandil on kaal (liitsõnal suurem kui lihtsõnal, harval sõnal suurem kui sagedal) ja igal teisendusel on kaal; kogukaal on nende summa. Mida suurem kaal, seda suurem on kahtlus tulemuse õigsuses.
         
       Käivita `./teisenda_sonavara_nyydseks1.sh`
        
       Tulemus: `../sonavara/algne_nyydne.vers2` kujul *mitu algne nüüdne kaal*


   3. Kas nüüdsena pakutav sõna ikka on tolleaegse variant? Kui nüüdse vormi summaarne kogukaal on väga suur, siis teisendusi oli liiga palju ja kaasaegne polegi tolleaegse uuem kuju, vaid mingi muu sõna. Suure kaaluga sõnad võivad olla valesti kaasajastatud, aga ei pruugi... Kaalu lisab ka see, kui sõna on liitsõna - see suurendab ebakindlust. Et kaalu alusel otsustada sõna sobivust, oleks hea, kui ebakindluse määraks ainult teisenduse kaal, mitte sõnavormi keerukus või sagedus üldiselt. Selleks võiks siinses korpuses esinevad sõnavormid lisada leksikonile tänapäevasel kujul. 
       
       Käivita  `./teisenda_sonavara_nyydseks2.sh`

       Tulemus: `../sonavara/algne_nyydne.vers3` kujul *mitu algne nüüdne kaal*

       Meetod: Oleta, et kuni kahetäheline tolleaegne ja väikese kaaluga kaasaegne sõna on õige; lisa need spelleri sõnaloendile (kaaluga 0) ning tee uus muundur. 
       Teisenda ja kontrolli uue muunduriga - kaasagse sõna kaal sõltub nüüd ainult teisendustest.
       (Ka paar vigast sõna osatakse nüüd õigeks parandada.)

   4. Pärisnimed võiks lisada leksikonile algsel kujul (ning teisendusega w -> v, sh -> š), v.a. 20 teisendatavat (nt Egüptus - Egiptus)

       Käivita `./tee_nimemuundur.sh`
       
       Tulemus: `algnimed.hfst`
       
       Meetod: Loe nimeks lause keskel suure algustähega sõna ja lause esimene sõna, millest väikese algustähega varianti ei leidu.

   5. Teisenda sõnavormid tänapäevasteks: teisenda ja kontrolli (spelleri) sõnastiku, korpuse leksikoni ja pärisnimedega, kas saadud sõna on analüüsitav kui kaasaegne. Teisendused ja sõnastikud-leksikonid on kokku pandud lõplikuks muunduriks.

       Käivita `./teisenda_sonavara_nyydseks3.sh`

       Tulemus: `../sonavara/algne_nyydne.vers4` kujul *mitu algne nüüdne kaal*

       3000 sõnavormi kaasajastamine ei õnnestu

2. Tee lõplik sõnavormide tabel *tollane nyydne* ja sellest muundur 

   Käivita `./teisenda_sonavara_muunduriks.sh`
   
   Tulemus: `aaa.hfstol`

3. Teisenda tokyo-failides sisuteksti sisaldavad read kujule sõnavorm-real (s.t. asendab tühikud reavahetustega), sest sellise kuju peal saab sõnavormid mugavalt asendada tänapäevastega.

    Käivita Pythoni skript (lähte- ja sihtkataloogi nimega): `./tyhik_rvks.py ../tokyo/ ../tokyo_rv`

4. Asenda sõnavormid nüüdsetega, kasutades muundurit `aaa.hfstol`

    Käivita `./teisenda_ak_nyydseks.sh`

    Lähtekataloog: `tokyo_rv`

    Sihtkataloog: `tokyo_nyydne_rv`

5. Teisenda reavahetused tagasi tühikuteks, nii et tulemus on vormi poolest samasugune kui tokyo-failis.

   Käivita Pythoni skript (lähte- ja sihtkataloogi nimega): `./rv_tyhikuks.py ../tokyo_nyydne_rv/ ../tokyo_nyydne`


