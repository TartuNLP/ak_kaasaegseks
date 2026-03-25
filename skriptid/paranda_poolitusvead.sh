#!/bin/sh

# leiab ja parandab poolitusmärgid: xxx-ja, xxx-wõi, soovi-wad jms
# kasutamine: paranda_poolitusvead.sh

# pärast tuleb uued failid käsitsi kopeerida (sest ei julge automaatselt parandatud faile algsete asemele kopeerida)

alg=../tokyo/
tulem=../uus_tokyo

# 1. tee parandamiseks sed-i fail 
# oletan, et parandamise mustrid on nii pikad, et ükski neist kogemata õiget asja ei paranda

# leia sõnad, mis olid algselt poolitatud ja mis on nüüd poolitusmärgiga, mistõttu neid ei tunta ära
# võta kriipsuga sõna, eemalda sealt kriips ja vaata, kas siis on ära tuntav

# NB! peab olema tehtud muundur: teisendused + spelleri leksikon 

cat ../sonavara/asutava_tekst \
| sed 's/ /\n/g' | grep '[[:alpha:]][[:alpha:]][\-][[:alpha:]]' \
| grep -v '\-ja$' \
| sort | uniq -c \
> ../vahetulemused/kriipsuga.mitu

cat ../vahetulemused/kriipsuga.mitu \
| tr -s ' ' | cut -d " " -f 3 \
| sed 's/[;:,\.?!\)]$//' \
| hfst-lookup -q -b 0 ttt.hfstol \
| gawk '{if ($1!=esi) {esi=$1; print} }' | grep '.' \
> ../vahetulemused/kriipsuga.tmp1

echo 's/-ja /- ja /g' > sedifail.tmp
echo 's/-wõi /- wõi /g' >> sedifail.tmp

paste  ../vahetulemused/kriipsuga.mitu ../vahetulemused/kriipsuga.tmp1 \
| sed 's/,000000//' \
| grep -v 'ii-kui-nii' \
| grep -v 'ja-ga' \
| grep -v 'üks-kord-üks' \
| grep -v 'reeka-katolik' \
| grep -v 'ühte-teist' \
| gawk '{if ($3 ~ "-" && $4 !~"-" && $5 < 300) print $3 }' \
| sed 's/^\([^\-]*\)\-\([^\-]*\)$/s\/&\/\1\2\//' \
| sed 's/kommisoni/kommisjoni/' \
>> sedifail.tmp

# 2. paranda protokolle ja pane failid uude kataloogi

# tee tulemkataloog
if ! [ -d "${tulem}" ] ;
then
    mkdir ${tulem}
fi

for file in `ls ${alg}/`
    do
    echo ${file} 
    cat ${alg}/${file} | sed -f sedifail.tmp > ${tulem}/${file}
    done

# kustuta vahefailid
#rm ../vahetulemused/kriipsuga.mitu ../vahetulemused/kriipsuga.tmp1 sedifail.tmp

