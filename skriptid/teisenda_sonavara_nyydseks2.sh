#!/bin/bash
# proovi kasutada juba tehtud teisendusi, et veelgi paremini teisendada
# probleemid:
# 1. korpuse sõnavaras on sõnu, mis morfi leksikonis puuduvad ja seetõttu nende kaasajastamine ebaõnnestub
#   -- tahaks muundurit täiendada korpuse sõnavaraga, aga kuidas?
# 2. kui sõna teisenduskaal on üsna suur, siis see võib tähendada halba teisendust, aga võib tähendada ka
# morf analüüsi keerukust (sest on liitsõna)
#   -- kui morfi keerukust mitte arvestada, siis saab ehk veel mõnede sõnavormide kaasajastamise edukaks lugeda? 
#      idee: sõnavormid, mille kaasajastamine oli kindlasti edukas, võiks muundurisse lisada
#            ja uuesti teisendusi proovida 

# skript teisenda_sonavara_nyydseks.sh peab olema tekitanud faili ../sonavara/algne_nyydne.vers2

# võta hästi kaasajastatud sõnavormid
# veerud: mitu, tokyo sõnavorm, tänapäevane sõnavorm, kaal
# (võib-olla peaks kuidagi teisiti kokku panema ja veerge kuidagi teisiti eraldama)
# sõna pikkusega 1 või 2 ei teisenda; see läheb nagu oli

cat ../sonavara/algne_nyydne.vers2 \
| sed 's/,000000//g' \
| gawk '{pik=length($2); if ($4 < 155 && pik > 2) {print($3)} else {if (pik < 3) print($2)}}' \
| grep -v 'nie' | grep -v 'irk' | grep -v 'Herm' | grep -v 'ioob' | grep -v 'Konsa' \
| grep -v 'Daani' | grep -v 'Oinas' | grep -v 'Ermus' | grep -v 'Lohki' | grep -v 'Konsa' \
| grep -v 'Kirna' | grep -v 'maasamine' | grep -v 'Sobranie' | grep -v 'maarippa' | grep -v 'Bullerian' \
| grep -v 'Krussa' | grep -v 'Witte' | grep -v 'Sobranie' | grep -v 'maarippa' | grep -v 'Bullerian' \
> ../vahetulemused/nyydsone_kaalutu.tmp1

#---------
echo 'LEXICON Root' > ../vahetulemused/nyydsone_kaalutu.lexc

cat ../vahetulemused/nyydsone_kaalutu.tmp1 \
| sed 's/$/ # ;/' \
>> ../vahetulemused/nyydsone_kaalutu.lexc

cat ../vahetulemused/nyydsone_kaalutu.lexc | hfst-lexc > nyydsone_kaalutu.hfst

# tee teisenduste muundur teisenda_vead.hfst ja ühenda see leksikoniga

printf "set encode-weights ON\nset flag-is-epsilon ON\nread regex [ @\"teisenda.hfst\" .o. [@\"nyydsone_kaalutu.hfst\" | @\"mrflex.hfst\"]];\nsave stack kkk.hfst\n" | hfst-xfst
cat kkk.hfst | hfst-fst2fst --optimized-lookup-weighted > kkk.hfstol

# ... ja kasuta
# (kuna võib juhtuda, et sama kaaluga on mitu tulemust, siis kasuta awki ja vali neist üks)
# ....või  hfst-proc -x -W -N 1 kkk.hfstol <-- see on vist kiirem, aga sõnaga kalamehi andis teistsuguse kaalu...
cat ../vahetulemused/algsone.veerg2 | hfst-lookup -q -b 0 kkk.hfstol \
| gawk '{if ($1!=esi) {esi=$1; print} }' | grep '.' \
> ../vahetulemused/nyydsone.tmp2

# pane veerud kokku
# tulemuseks on: mitu, tokyo sõnavorm, tänapäevane sõnavorm, kaal
# (võib-olla peaks kuidagi teisiti kokku panema ja veerge kuidagi teisiti eraldama)
paste ../sonavara/asutava_soned.mitu ../vahetulemused/nyydsone.tmp2 \
| cut -f 1,3,4 \
> ../sonavara/algne_nyydne.vers3

# kaasajastamata jääb: u. 1900 on liiga suure kaaluga + 5200 on ilma analüüsita (s.t. ? inf)

exit


