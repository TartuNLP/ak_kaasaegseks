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

# skript teisenda_sonavara_nyydseks2.sh peab olema tekitanud faili ../sonavara/algne_nyydne.vers3
# skript tee_nimemuundur.sh peab olema tekitanud faili ../vahetulemused/algnimed.son

# võta hästi kaasajastatud sõnavormid
# veerud: mitu, tokyo sõnavorm, tänapäevane sõnavorm, kaal
# (võib-olla peaks kuidagi teisiti kokku panema ja veerge kuidagi teisiti eraldama)
# sõna pikkusega 1 või 2 ei teisenda; see läheb nagu oli

#  ühenda teisenda.hfst leksikonidega ja kasuta

printf "set encode-weights ON\nset flag-is-epsilon ON\nread regex [ @\"teisenda.hfst\" .o. [@\"nyydsone_kaalutu.hfst\" | @\"algnimed.hfst\" | @\"mrflex.hfst\"]];\nsave stack ppp.hfst\n" | hfst-xfst
cat ppp.hfst | hfst-fst2fst --optimized-lookup-weighted > ppp.hfstol

# ... ja kasuta
# (kuna võib juhtuda, et sama kaaluga on mitu tulemust, siis kasuta awki ja vali neist üks)
# ....või  hfst-proc -x -W -N 1 kkk.hfstol <-- see on vist kiirem, aga sõnaga kalamehi andis teistsuguse kaalu...
cat ../vahetulemused/algsone.veerg2 | hfst-lookup -q -b 0 ppp.hfstol \
| gawk '{if ($1!=esi) {esi=$1; print} }' | grep '.' \
> ../vahetulemused/nyydsone.tmp3

# teisenda liitsõna algusosad nyydisaegseks
cat ../vahetulemused/algsone.veerg1 \
| sed 's/w/v/g' \
> ../vahetulemused/algsone.veerg11

# pane veerud kokku
# tulemuseks on: mitu, tokyo sõnavorm, tänapäevane sõnavorm (milles võib olla alakriips liitsõnas), kaal
# (võib-olla peaks kuidagi teisiti kokku panema ja veerge kuidagi teisiti eraldama)
 
cat ../vahetulemused/nyydsone.tmp3 \
| sed 's/,000000//g' \
| sed 's/+?\t/\t/' \
| cut -f 2,3 \
| paste ../vahetulemused/algsone.veerg11 - \
| sed 's/\t/_/' | sed 's/^_//' \
| paste ../sonavara/asutava_soned.mitu - \
| tr '\t' '@' \
\
| sed 's/ \(annud\)@anud@/ \1@andnud@/' \
| sed 's/ \(Oinase.*\)@Omase/ \1@Oinase/' \
| sed 's/ \(kunni\)@kunni@/ \1@kuni@/' \
| sed 's/ \(Kunni\)@\1@/ \1@Kuni@/' \
| sed 's/ \([nN]äi\)tusi@\1tusi@/ \1tusi@\1teid@/' \
| sed 's/ \([nN]äi\)tus@\1tus@/ \1tus@\1de@/' \
| sed 's/ \([nN]äi\)tuse\([^l]*\)@\1tuse\2@/ \1tuse\2@\1te\2@/' \
| sed 's/ \([^@]*..\)\(toobi\)@\1tobi@/ \1\2@\1\2@/' \
| sed 's/ \([^@]*..\)\(toopi\)@\1topi@/ \1\2@\1\2@/' \
| sed 's/ \([^@ ]*\)\(õõdu\)\(...*\)@\1õdu\(.*\)@/ \1\2\3@\1\2\4@/' \
| sed 's/ \([^@]*\)\(wäärt\)@\(.*\)vaart@/ \1\2@\3väärt@/' \
\
| tr '@' '\t' \
> ../sonavara/algne_nyydne.vers4


# kaasajastamata jääb: u. 1000 on liiga suure kaaluga + 2200 on ilma analüüsita (s.t. ? inf) + suurekaalulisi tuleks osalt käsitsi läbi vaadata

exit


