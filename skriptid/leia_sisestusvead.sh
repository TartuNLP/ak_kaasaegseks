#!/bin/sh

# idee: kui ainukordne sõnavorm erineb mitmekordsest sellise täheteisenduse poolest,
# mis on tõenäoliselt sisestusviga, siis võiks selle automaatselt ära parandada
# (kõiki vigu niimoodi muidugi kätte ei saa)

# vaja teha:
# 1. korpuse leksikon, s.t. rohkem kui 1 korda esinevate loend
# 2. tõenäoliste sisestusvigade muundur
# 3. pane 1 ja 2 kokku muunduriks
# 4. rakenda muundurit, et leida võimalikud vead 

echo 'LEXICON Root' > asutava_sonastik.lexc

cat ../sonavara/asutava_soned.mitu \
| grep -v ' 1 ' \
| tr -s ' ' \
| cut -d " " -f 3 \
| sed 's/$/ # ;/' >> asutava_sonastik.lexc

cat asutava_sonastik.lexc | hfst-lexc > asutava_sonastik.hfst

# tee teisenduste muundur teisenda_vead.hfst ja ühenda see leksikoniga

echo 'save stack teisenda_vead.hfst' | hfst-xfst -l teisenda_vead.xfscript

printf "set encode-weights ON\nread regex [ @\"teisenda_vead.hfst\" .o. @\"asutava_sonastik.hfst\" ];\nsave stack vvv.hfst\n" | hfst-xfst
cat vvv.hfst | hfst-fst2fst --optimized-lookup-weighted > vvv.hfstol

# ... ja kasuta
# (kuna võib juhtuda, et sama kaaluga on mitu tulemust, siis kasuta awki ja vali neist üks)
cat ../vahetulemused/algsone.veerg | hfst-lookup -q -b 0 vvv.hfstol \
| gawk '{if ($1!=esi) {esi=$1; print} }' | grep '.' \
| cut -f 2,3 \
| paste ../sonavara/algne_nyydne.vers1 - \
> ../sonavara/algne_nyydne_veatu.vers1

# 6 välja: 
# $1=sagedus (alati 1); $2=algne $3=nyydne $4=kaal nüüdseks teisendamisel; 
# $5=sarnane korpusevorm; $6=kaal korpusevormiks teisendamisel
# kuidas otsustan, et sõnavormi asemele tuleb kirjutada korpuse muu sõnavorm?
# 1) uus sõnavorm = mõni teine sõnavorm sellest korpusest (mille sagedus on vähemalt 2)
# 2) seejuures paranduste kogukaal on väiksem kui kogukaal teisendamisel vabamorfi leksikoni kujule
# (vabamorfi leksikoni puhul kogukaal = parandused + leksikonist tulenev kaal)
# ... s.t. et selle korpuse sõnavorm on parem kandidaat kui vabamorfi sõnavorm
# 3) maks 2 teisendust
# 4) algse pikkus vähemalt 4
# 5) kui algse pikkus = 4, siis üle 1 paranduse ei tohi olla  

# tekita kaheveeruline tabel: vigane \t korras
cat ../sonavara/algne_nyydne_veatu.vers1 \
| sed 's/,000000//g' \
| gawk '{if ($6 != 0 && $6 !="inf" && $6 <= $4 && $6 <= 600 && $2 != $3 && length($2) > 3 && !($6==600 && length($2)==4)) print ($2 "\t" $5)}' \
> ../sonavara/viga_korras.tab

exit

katsetamiseks:
cat ../sonavara/algne_nyydne_veatu.vers1 | sed 's/,000000//g' | gawk '{if ($6 != 0 && $6 !="inf" && $6 <= $4 && $6 <= 600 && $2 != $3) print}' | sort -nr -k 6 | wc -l
470


