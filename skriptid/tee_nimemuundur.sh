#!/bin/sh
# tee korpuse pärisnimede muundur
# s.t. leia nimed ja nende käänamisviisid

cat ../sonavara/algne_nyydne.vers3 \
| tr -s ' ' | tr ' ' '\t' \
| cut -f 3 \
| grep "['’]" \
| grep '^[[:upper:]]' \
| sed "s/^\([^'’]*\)['’]\(.*\)$/\1 \2/" \
> ../vahetulemused/nimed_loppudega.vers1

# idee: leia suure algustähega sõnad,
# mis ei esine kunagi väikese algustähega

# leia väikese algustähega sõnad
cat ../sonavara/algne_nyydne.vers3 \
| tr -s ' ' | tr ' ' '\t' \
| cut -f 3 \
| grep '^[[:lower:]]' \
> ../vahetulemused/v_algus.son

# leia suure algustähega sõnad
cat ../sonavara/algne_nyydne.vers3 \
| tr -s ' ' | tr ' ' '\t' \
| cut -f 3 \
| grep '^[[:upper:]]' \
> ../vahetulemused/s_algus.son

# kaks veergu: 
# 1. väikese algustähega esinenud sõna, millel esimene täht on tehtud suureks
# 2. algtekstis suure algustähega esinenud sõna
# kui reas on ### Sõna
# siis järelikult sellest sõnast väikese algustähega vormi korpuses pole

cat ../vahetulemused/v_algus.son \
| sed 's/^./\U&/' \
| join -a 1 -a 2 -e "###" -o 1.1 2.1 - ../vahetulemused/s_algus.son \
| grep '^###' | cut -d " " -f 2 \
> ../vahetulemused/nimekandidaadid.son

# korpuses lause alguses olevad sõnad.
# (eeldab, et lausestus on õige)
# korja tekst kokku samal moel kui uuri_asutava_sonavara.sh
alg=../tokyo/
sonavara=../sonavara

echo "" > ${sonavara}/asutava_tekst

# korja tekst xml formaadis failidest kokku
for file in `ls ${alg}/*.xml`
    do
    echo ${file}
    cat ${file} | sed '1,/<\/bibliographical_data>/d' | grep '<s' | sed 's/<[^<>]*>//g' | sed 's/\r//g' >> ${sonavara}/asutava_tekst
    done

# eemalda igast lausest kõik kuni esimese suurtähega algava sõnani ja see sõna ise ka
# ... ja siis eemalda ja teisenda sama moodi nagu uuri_asutava_sonavara.sh
# reas võib olla Pealkiri. § nr. Pealkiri; igaks juhuks tõsta iga § nr järgmisele reale
# kui alguses on III. või E. siis eemalda see, et lause saaks tavaviisil alata
# kui alguses on Märkus: <suurtäht> siis eemalda Märkus:
# jutumärkides osa tõsta omaette reale ja tekita kunstlik Aa
# lause keskel suur sõna võiks olla nimi, v.a. juhul, kui lausestus on vigane

cat ../sonavara/asutava_tekst \
| sed 's/§ [1234567890][1234567890]*/\n&/g' \
| sed 's/^ *Märkus:  *\([ABCDEFGHIJKLMNOPQRSTUVWÕÄÖÜŠŽXY]\)/\1/' \
| sed 's/ \([“”„"][ABCDEFGHIJKLMNOPQRSTUVWÕÄÖÜŠŽXY][^“”„"]*[“”„"]\)/ \n\1\nAa /g' \
| sed 's/^ *[ABCDEFGHIJKLMNOPQRSTUVWÕÄÖÜŠŽXY][ABCDEFGHIJKLMNOPQRSTUVWÕÄÖÜŠŽXY\.-]* //g' \
| sed 's/^[^ABCDEFGHIJKLMNOPQRSTUVWÕÄÖÜŠŽXY]*[ABCDEFGHIJKLMNOPQRSTUVWÕÄÖÜŠŽXY][^ ][^ ]* //' \
| sed 's/^.*>//' \
| sed 's/\^//' \
| sed 's/$/@/' | tr -d '\n' | sed 's/\-@//g' | tr '@' '\n' \
| sed 's/[01234567890\.,:;?!"()“”„§\/+#=%½¶¹°˚…＿£—–_»«}\*\-]/ /g' \
| tr '\t' ' ' \
| sed 's/ /\n/g' \
| grep '^[ABCDEFGHIJKLMNOPQRSTUVWÕÄÖÜŠŽXY]' \
| sort | uniq \
> ../vahetulemused/lause_keskel_suured.son

# tahaks eemaldada potentsiaalsete nimede loendist need sõnad, mis ei esine 
# suurtähelisena mujal kui ainult lause alguses

# panen kokku sõnad:
# 1. millest väikese algustähega vormi korpuses pole
# 2. millest on suure algustähega vorm lause sees (mitte alguses)
# jätan alles ainult need sõnad, mis on mõlemas loendis

join -a 1 -a 2 -e "###" -o 1.1 2.1 ../vahetulemused/nimekandidaadid.son ../vahetulemused/lause_keskel_suured.son \
| grep -v '###' | cut -d " " -f 1 \
> ../vahetulemused/nimekandidaadid2.son

# viga: siin on ka rooma numbrid
# ... siin loendis võib olla ikkagi veel selliseid, mis on tegelt üldnimi, nt. Ülemleitnant
# kui selline on analüüsitav lihtsõnana, siis võib-olla ikka pole pärisnimi
# aga teiselt poolt, on ka selliseid pärisnimesid nagu Üürike ja Õun, mis on ka lihtsõnana analüüsitavad...
# võib-olla aitaks siin suurtähelise ja väiketähelise vormi arvuline vahekord: kui suurtähelisi suhtel. palju, siis võiks ikkagi olla pärisnimi? nt Aule 4; aule 1

# teisenda ...
# NB! kas kkk.hfstol või kkkk.hfstol ???
cat ../vahetulemused/nimekandidaadid2.son | hfst-lookup -q -b 0 kkk.hfstol \
| gawk '{if ($1!=esi) {esi=$1; print} }' | grep '.' \
> ../vahetulemused/nimekandidaadid2.kaaludega

# mõnda nime ei tohi teisendada, sest see moonutaks seda valel moel
# sellise võiks lisada leksikoni, siis seda ei teisendatagi
# 
cat ../vahetulemused/nimekandidaadid2.kaaludega \
| sed 's/,000000//g' \
| gawk '{if ($3 > 20) print}' \
| grep -v 'Amalie' | grep -v 'Mehhiko' | grep -v 'Mihhail' \
| grep -v 'Oinas' | grep -v 'Tšehh' | grep -v 'Kuramaa' | grep -v 'Tohoh' \
| grep -v 'Asutavasse' | grep -v 'Anastasia' | grep -v 'Estonia' \
| grep -v 'Kanada' | grep -v 'Peterbur' | grep -v 'Otepää' | grep -v 'Dvigatel' \
| grep -v 'Slovaki' | grep -v 'Egiptus' | grep -v 'Valentina' \
| grep -v 'Weizenberg' | grep -v 'Wiedemann' | grep -v 'Westholm' | grep -v 'Wollbrück' \
| cut -f 1 \
> ../vahetulemused/algnimed.son

# tekita nime nüüdisversioon (w -> v, sh -> š)
cat ../vahetulemused/algnimed.son \
| sed 's/Schweits/Šveits/' \
| sed 's/Tshernoshev/Tšernošev/' \
| sed '/\(New$\)\|\([sScC]hw\)/!s/w/v/g' \
| sed 's/W/V/g' \
| sed 's/\([^f]\)tsh/\1tš/g' \
| sed 's/Tsh/Tš/g' \
| sed 's/shk/šk/g' \
| sed 's/Posharski/Požarski/g' \
> ../vahetulemused/uusnimed.son

#---------
echo 'LEXICON Root' > ../vahetulemused/algnimed.lexc

paste -d: ../vahetulemused/algnimed.son ../vahetulemused/uusnimed.son \
| sed 's/$/ # ;/' \
>> ../vahetulemused/algnimed.lexc

cat ../vahetulemused/algnimed.lexc | hfst-lexc > algnimed.hfst


#-----
# siia peaks omakorda lisama nimed, mis väiketähelisena on tavasõnad, nt. Aule, Anna
# märgendatud esinejad:
grep '<div1 sp=' ${alg}/*.xml \
| sed 's/^.*<div1 sp="//' | sed 's/".*$//' \
| sort -u \
> ../vahetulemused/esinejad.son

# siin jäi pooleli...

# et leida tavasõnu, mis on suurtähelisena lause keskel:
# grep '^###' | cut -d " " -f 2 | less

exit



cat ../alg_tokyo/* | grep '<s' | sed 's/<s[^>]*>  *[^ ][^ ]* //' | sed 's/^[1234567890][1234567890]*[\.]  *[^ ][^ ]* //' | less
