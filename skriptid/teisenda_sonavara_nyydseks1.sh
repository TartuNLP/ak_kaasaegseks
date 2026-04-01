#!/bin/bash
# Eesimene katse: rakenda tokyo-sõnavormile kõiksugu teisendusi (nt. w -> v, ü -> ii) ja 
# kontrolli spelleri leksikoniga, kas saadud sõnavorm on tänapäevane.
# Igal teisendusel on kaal ja mitme teisenduse kaalud summeeruvad. Tänapäevaseks sõnavormiks pakub 
# programm sellise, mille kaal on väikseim. Kui sõna ongi juba tänapäevane, siis teisendusi pole vajagi 
# ja nende summaarne kaal 0. Kui aga tokyo-sõnast saab tänapäevase ainult paljude teisenduste kaudu, 
# siis nende kaal on suur ja tegelikult saadud tulemus ei olegi õige.

# tokyo-sõnavorm võib olla sisestatud vigasena (nt m asemel on rn); ka sisestusvea teisendusi siin proovitakse

# *** NB! eeldab, et masinas on HFST pakett ja eesti muundurid ***
# mis on HFST ja kuidas installida, vt  https://github.com/hfst/hfst
# mis on eesti muundurid ja kuidas neid teha, vt https://github.com/giellalt/lang-est-x-utee
# 

# vahetulemused paneb kataloogi ../vahetulemused
if ! [ -d "../vahetulemused" ] ; then
    mkdir ../vahetulemused
fi

# tee algsete sõnade loend
cat ../sonavara/asutava_soned.mitu | sed 's/^  *\([1234567890][1234567890]*\) //' > ../vahetulemused/algsone.veerg

# jaga teadaolevad ebasobivad liitsõnad kaheks
# tekita kaks veergu
cat  ../vahetulemused/algsone.veerg \
| sed 's/^\([kK]õige\)\(....*\)$/\1 \2/' \
| sed 's/^\(.*[aeiu]\)\(alla*\)$/\1 \2/' \
| sed 's/^\([mM]aata\)\([aeioum].*\)$/\1 \2/' \
| sed 's/^\(.*se\)\(aja\)$/\1 \2/' \
| sed 's/^\([aA]si\)\([aeiuoõäöü].*\)$/\1 \2/' \
| sed 's/^\([sS]elle\)\(kohta\)$/\1 \2/' \
| sed 's/^\([sS]elle\)\(jaoks\)$/\1 \2/' \
| sed 's/^\([sS]aja\)\(tuhande\)$/\1 \2/' \
| sed 's/^\([sS]ajad\)\([tm].*\)$/\1 \2/' \
| sed 's/^\([eE]luks\)\(ajaks\)$/\1 \2/' \
| sed 's/^\([tT]eie\)\(hulgast\)$/\1 \2/' \
| sed '/must/!s/^\(..*\)\(tuhat\)$/\1 \2/' \
| sed '/ndeli/!s/^\([^a]..*\)\(tuhan\)$/\1 \2/' \
| sed 's/^\([üÜ]hel\)\([hm].*\)$/\1 \2/' \
| sed 's/^\([pP]raegu\)\([^sng].*\)$/\1 \2/' \
| sed 's/^\(lutheri\)\(...*\)$/\1 \2/' \
| sed 's/\(kümmend\)\([^ ][^ ][^ ]*\)$/\1 \2/' \
| sed '/ /!s/^/ /' | tr ' ' '\t' \
> ../vahetulemused/algsone.vahelkaks

# tõsta veerud lahku, et oleks parem askeldada
cat ../vahetulemused/algsone.vahelkaks \
| cut -f 1 \
> ../vahetulemused/algsone.veerg1

# edaspidi tegelen ainult selle tagumise veeruga
cat ../vahetulemused/algsone.vahelkaks \
| cut -f 2 \
> ../vahetulemused/algsone.veerg2


# ... ja mitu-tk veerg (lihtsalt niisama)
cat ../sonavara/asutava_soned.mitu | sed 's/^  *\([1234567890][1234567890]*\) .*/\1/' > ../vahetulemused/algmitu.veerg

# tee teisenduste muundur teisenda.hfst ja ühenda see leksikoniga
#  seega ttt.hfst teeb teisendused ainult juhul, kui tulemuseks on leksikoni kuuluv sõna

echo 'save stack teisenda.hfst' | hfst-xfst -l teisenda.xfscript
echo 'save stack mrflex.hfst' | hfst-xfst -l mrflex.xfscript

echo 'save stack ttt.hfst' | hfst-xfst -l ttt.xfscript
cat ttt.hfst | hfst-fst2fst --optimized-lookup-weighted > ttt.hfstol


# ... ja kasuta
# (kuna võib juhtuda, et sama kaaluga on mitu tulemust, siis kasuta awki ja vali neist üks)
cat ../vahetulemused/algsone.veerg2 | hfst-lookup -q -b 0 ttt.hfstol \
| gawk '{if ($1!=esi) {esi=$1; print} }' | grep '.' \
> ../vahetulemused/nyydsone.tmp1

# pane veerud kokku
# tulemuseks on: mitu, tokyo sõnavorm, tänapäevane sõnavorm, kaal
# (võib-olla peaks kuidagi teisiti kokku panema ja veerge kuidagi teisiti eraldama)
paste ../sonavara/asutava_soned.mitu ../vahetulemused/nyydsone.tmp1 \
| cut -f 1,3,4 \
> ../sonavara/algne_nyydne.vers2

exit









