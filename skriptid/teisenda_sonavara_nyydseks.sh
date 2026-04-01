#!/bin/bash
# Teisenda Asutawa Kogu sõnavormid tänapäevaseks
# tulemuseks on ../sonavara/algne_nyydne.vers4

# 1. Tee tokyo-failidest sõnavormide loend. 

# Tulemus: ../sonavara/asutava_soned.mitu kujul mitu <tyhik> sõnavorm
# Sõnavara suurus on 85 000 sõnavormi.
./uuri_asutava_sonavara.sh

# 2.1. Tükelda mõned sõnavormid kaheks (nt. kõigeõigem), sest need kirjut. tänap lahku.
# 2.2. Teisenda sõnad tänapäevasteks: teisenda ja kontrolli spelleri sõnastikuga, et tulemus oleks kaasaegne sõna.   
# Igal teisendusel on kaal; kui kaasaegse vormi kogukaal on väga suur, 
# siis teisendusi oli liiga palju ja kaasaegne polegi tolleaegse uuem kuju, vaid muu sõna.

./teisenda_sonavara_nyydseks1.sh
# Tulemus: tabel ../sonavara/algne_nyydne.vers2 kujul *mitu algne nüüdne kaal*

# Probleem: suure kaaluga sõnad võivad olla valesti kaasajastatud, aga ei pruugi...
# Kui nüüdse vormi summaarne kogukaal on väga suur, siis teisendusi oli liiga palju ja 
# kaasaegne polegi tolleaegse uuem kuju, vaid mingi muu sõna. 
# Suure kaaluga sõnad võivad olla valesti kaasajastatud, aga ei pruugi... 
# Kaalu lisab ka see, kui sõna on liitsõna - see suurendab ebakindlust. 
# Et kaalu alusel otsustada sõna sobivust, oleks hea, kui ebakindluse määraks ainult teisenduse kaal, 
# mitte sõnavormi keerukus või sagedus üldiselt. 
# Selleks võiks siinses korpuses esinevad sõnavormid lisada leksikonile tänapäevasel kujul. 

# 3. Oleta, et kuni kahetäheline tolleaegne ja väikese kaaluga kaasaegne sõna on õige; 
# lisa need korpuse sõnad spelleri sõnaloendile (kaaluga 0) ning tee uus muundur. 

# Teisenda ja kontrolli uue muunduriga - kaasagse sõna kaal sõltub nüüd ainult teisendustest.
# (Ka paar vigast sõna osatakse nüüd õigeks parandada.)

./teisenda_sonavara_nyydseks2.sh
# Tulemus: tabel ../sonavara/algne_nyydne.vers3 kujul *mitu algne nüüdne kaal*

# Spelleri sõnavara ei kata AK sõnavara täielikult - puuduvad pärisnimed.  
# Pärisnimed võiks lisada leksikonile algsel kujul (ning teisendusega w -> v, sh -> š),
# v.a. 20 teisendatavat (nt Egüptus - Egiptus)
# ... nimesid peaks ehk veel teisendama, nt Sohwia --> Sofia, Shipka --> Šipka ?
# Nimeks loetakse korpuses lause keskel olevat suure algustähega sõna, millest väikese algustähega varianti ei leidu.

./tee_nimemuundur.sh
# Tulemus: algnimed.hfst

# 4. Teisenda tavalised sõnad, ära teisenda nimesid ega alla 3 tähelisi;
# Järele jääb u 3000 tavalist sõna, mida peaks kaasajastama, aga see ei õnnestu

./teisenda_sonavara_nyydseks3.sh
# Tulemus: tabel ../sonavara/algne_nyydne.vers4 kujul *mitu algne nüüdne kaal*





