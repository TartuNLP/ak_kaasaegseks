#!/bin/bash
# Asendab AK korpuse tekstides tolleaegsed sõnavormid tänapäevastega, jättes kõik muu (märgenduse, paigutuse) endiseks.

# Meetod: leia igale korpuse sõnavormile selle tänapäevane vaste (s.t. tegele korpuse sõnavaraga) 
# ja kui see on tehtud, siis kasuta leitud sõnapaare, et asendada tekstis tollased sõnad nüüdsetega.
# Korpuse sõnad, millele tänapäevast varianti ei leita, tuleb jätta endiseks: nimed, lühendid.

# Lähtekataloog: `tokyo`
# Sihtkataloog: `tokyo_nyydne`

# 1. Tee tokyo-failidest 2-veeruline sõnavormide tabel: tollane <tab> nyydne
./teisenda_sonavara_nyydseks.sh

# 2. Tee sõnavormide tabeli alusel muundur aaa.hfstol
./teisenda_sonavara_muunduriks.sh

# 3. Teisenda tokyo-failides sisuteksti sisaldavad read kujule sõnavorm-real 
# (s.t. asenda tühikud reavahetustega), 
# sest sellise kuju peal saab sõnavormid mugavalt asendada tänapäevastega.
./tyhik_rvks.py ../tokyo/ ../tokyo_rv


# 4. Asenda sõnavormid nüüdsetega,
# kasutades muundurit aaa.hfstol

./asenda_sonad_nyydsetega.sh ../tokyo_rv ../tokyo_nyydne_rv

# 5. Teisenda reavahetused tagasi tühikuteks, nii et tulemus on vormi poolest samasugune kui tokyo-failis.
./rv_tyhikuks.py ../tokyo_nyydne_rv ../tokyo_nyydne



