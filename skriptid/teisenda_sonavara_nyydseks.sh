#!/bin/bash
# teisenda Asutawa Kogu sõnavormid tänapäevaseks

# 1. tee tokyo-failidest sõnavormide loend 
./uuri_asutava_sonavara.sh

# 2.1. tükelda mõned sõnavormid kaheks (nt. kõigeõigem), sest need kirjut. tänap lahku
# 2.2. teisenda sõnad tänapäevasteks: teisenda ja kontrolli spelleri sõnastikuga, et tulemus oleks kaasaegne sõna    
# igal teisendusel on kaal; kui kaasaegse vormi kogukaal on väga suur, siis teisendusi oli liiga palju ja kaasaegne polegi tolleegse uuem kuju, vaid muu sõna
./teisenda_sonavara_nyydseks1.sh

# probleem: suure kaaluga sõnad võivad olla valesti kaasajastatud, aga ei pruugi...
# kaalu lisab ka see, kui sõna on liitsõna - see suurendab ebakindlust
# oleta, et väikese kaaluga kaasaegne sõna on õige; tee selliste loend
# ja lisa see spelleri sõnaloendile (kaaluga 0)
# 3. teisenda sõnad tänapäevaseks ja kontrolli spelleri+korpuse sõnadega 
# --> kaasagse sõna kaal sõltub nüüd ainult teisendustest
# (pluss paar vigast sõna, mis nüüd õigeks osatakse parandada)
./teisenda_sonavara_nyydseks2.sh

# spelleri sõnavara ei kata AK sõnavara täielikult - pärisnimed  
# pärisnimed võiks lisada leksikonile algsel kujul, v.a. 20 teisendatavat (nt Egüptus - Egiptus)
# ... nimesid peaks ehk veel teisendama, nt Sohwia --> Sofia, Shipka --> Šipka ?
./tee_nimemuundur.sh

# 4. teisenda tavalised sõnad, ära teisenda nimesid ega alla 3 tähelisi
# järele jääb u 3000 tavalist sõna, mida peaks kaasajastama, aga see ei õnnestu
./teisenda_sonavara_nyydseks3.sh

# tulemuseks on ../sonavara/algne_nyydne.vers4; aga siin peaks olema ka see äravõetud veerg...




