# Korpuse töötlemise programmid

## Tänapäevase sõnavara muundur

Tänapäevase sõnavara muundur mrflex.hfst on kasutusel sõnade teisendamise mõistlikkuse kontrollimisel.
See on tehtud lähtefailidest, mis on siin: https://github.com/giellalt/lang-est-x-utee
Seejuures sõnavara on sama, mis vabamorfi (https://github.com/Filosoft/vabamorf) spelleri sõnavara (sest vabamorfi leksikon on giellalt-lehele kopeeritud).

## AK sõnavormide kaasajastamine

Asendab AK korpuse tekstides tolleaegsed sõnavormid tänapäevastega, jättes kõik muu (märgenduse, paigutuse) endiseks.

Käivita `./teisenda_ak_nyydseks.sh`

Lähtekataloog: `tokyo`

Sihtkataloog: `tokyo_nyydne`

Meetod: leia igale korpuse sõnavormile selle tänapäevane vaste (s.t. tegele korpuse sõnavaraga) ja kui see on tehtud, siis kasuta leitud sõnapaare, et asendada tekstis tollased sõnad nüüdsetega. Korpuse sõnad, millele tänapäevast varianti ei leita, tuleb jätta endiseks: nimed, lühendid.

## Sõnavara teisendamine nüüdseks

Tee tokyo-failidest sõnavormide tabel kujul: *tollane nyydne*

Käivita `./teisenda_sonavara_nyydseks.sh`


