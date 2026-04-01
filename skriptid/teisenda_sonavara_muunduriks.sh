#!/bin/bash
# tekita varem tehtud teisenduste, sageduste ja muu alusel sõnavormide muundur

# tekita ignoreeritavate märkide automaat
# märkide loend on pärit mingist skriptist uuri_sonavara.sh vms...

echo '0123456789.,:;?!"()“”„§\/+#=%½¶¹°˚…＿£—–_«»}*-' \
| sed 's/./|"&"/g' \
| sed 's/|/ [/' \
| sed 's/$/]/' \
| sed 's/"""/%"/' \
| sed 's/"\\"/%\//' \
| sed 's/$/::1/' \
| hfst-regexp2fst -v > sodi.hfst


# tekita õige kaasaegsete veerg:
# paranda mõned vead, mille põhjuseks on sõnavorm leksikonis, mis eksitavalt lubab vale teisendust 
# vali kaasaegseks kas (1) väikese kaaluga vorm või (2) algne vorm, milles w --> v

cat ../sonavara/algne_nyydne.vers4 \
\
| gawk '{pik=length($2); if (pik < 5 && $4 <= 100) {print $3} else if (pik >= 5 && $4 <= 310)  {print $3} else {k = $2; gsub(/w/, "v", k); print(k)}}' \
| paste  ../sonavara/algne_nyydne.vers4 - \
| cut -f 1,4 \
> ../vahetulemused/mitualgne_nyydne.tab

cat ../vahetulemused/mitualgne_nyydne.tab \
| sed 's/^.* \([^ ]*\)$/\1/' \
> ../vahetulemused/algne_nyydne.tab

#---------
echo 'LEXICON Root' > ../vahetulemused/algne_nyydne.lexc

cat ../vahetulemused/algne_nyydne.tab \
| sed 's/$/ # ;/' \
| tr '\t' ':' \
>> ../vahetulemused/algne_nyydne.lexc

cat ../vahetulemused/algne_nyydne.lexc | hfst-lexc > algne_nyydne.hfst

# sõna ees ja taga võib olla sodi; võib olla ka sõna sodi sõna või ainult sodi
printf "set encode-weights ON\nset flag-is-epsilon ON\nread regex [ [@\"sodi.hfst\"]* [[@\"algne_nyydne.hfst\"]::1 | [@\"sodi.hfst\"]+] [[@\"sodi.hfst\"]* [@\"algne_nyydne.hfst\"]::1]* [@\"sodi.hfst\"]*];\nsave stack aaa.hfst\n" | hfst-xfst
cat aaa.hfst | hfst-fst2fst --optimized-lookup-weighted > aaa.hfstol


#cat algne_nyydne.hfst | hfst-fst2fst --optimized-lookup-weighted > algne_nyydne.hfstol

exit

