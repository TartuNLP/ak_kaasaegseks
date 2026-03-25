#!/bin/bash

# et uurida asutava kogu protokollide sõnavara

# kasutamine: olles ise kataloogis skriptid, käivita käsurealt ./uuri_asutava_sõnavara.sh

alg=../uusim_tokyo/
sonavara=../sonavara

echo "" > ${sonavara}/asutava_tekst

./korja_asutava_tekst.py ${alg} ${sonavara}/asutava_tekst   

# mis märgid siin kõik on
cat ${sonavara}/asutava_tekst | sed 's/./&\n/g' | grep '.' | sort | uniq -c > ${sonavara}/asutava_margid.mitu

# mis tühikuvahelised märgijadad siin kõik on
cat ${sonavara}/asutava_tekst | sed 's/ /\n/g' | sort | uniq -c > ${sonavara}/asutava_margijadad.mitu

# milline "mõistlik" sõnavara siin on
# eemalda sisse jäänud märgendid (neid tegelt ei tohikski olla)
# eemalda mitte-tähed (nt. numbrid, kirjavahemärgid) ja nende jadad

cat ${sonavara}/asutava_tekst \
| sed 's/<[^<>]*>//g' \
| sed 's/\^//' \
| sed 's/$/@/' | tr -d '\n' | sed 's/\-@//g' | tr '@' '\n' \
| sed 's/[01234567890\.,:;?!"()“”„§\/+#=%½¶¹°˚…＿£—–_«»}\*\-]/ /g' \
| tr '\t' ' ' \
| sed 's/ /\n/g' \
| grep '.' \
| sort | uniq -c > ${sonavara}/asutava_soned.mitu

exit

# alljärgnev püüab olla täpsem, lubades kriipsuga sõnavorme, aga ikka jääb üksjagu sodi sisse...

# milline "mõistlik" sõnavara siin on
# jäta välja ainult mitte-tähti sisaldavad sõned (nt. numbrid, kirjavahemärgid)
# eemalda sõna lõpust kirjavahemärgid
# eemalda sõna algusest kirjavahemärgid
# numbri ja sõna kombinatsioonid: kui on nr-sõna, siis jäta alles sõna; nr-lõpp kustuta (

cat ${sonavara}/asutava_tekst \
| sed 's/<[^<>]*>//g' \
| sed 's/ /\n/g' \
| grep -v '^[0123456789\.,:;?!"()“”„§\/+#=%½¶¹°˚…＿£—–_«»}\*\-]*$' \
| grep -v "^[0123456789\.,:;?'()“”„§\/+#=%½¶¹°˚…＿£—–_«»}\*\-]*$" \
| sed 's/[\.,:;?!"()“”„«»]*$//' \
| sed 's/^[\.,:;?!"()“”„«»]*//' \
| sed 's/^[0123456789\.\-—–][0123456789\.\-—–\/%]*\-\([[:alpha:]][[:alpha:]][[:alpha:]][[:alpha:]][[:alpha:]][[:alpha:]]\)/\1/' \
\
| grep -v '[0123456789].*\-.....$' \
| grep -v '[0123456789].*\-....$' \
| grep -v '[0123456789].*\-...$' \
| grep -v '[0123456789].*\-..$' \
| grep -v '[0123456789].*\-.$' \
\
| grep '.' \
| sort | uniq -c > ${sonavara}/asutava_soned.mitu2

exit 

mis siin veel on:
cat ../sonavara/asutava_soned.mitu2 | sed 's/^.* \([^ ]*\)$/\1/' | grep '[^[:alpha:]]' | grep '\-....$' | less



#rm ${sonavara}/asutava_tekst  # puhasta: kustuta tekitatud tekstifail
exit

keelt tähistavad märgendid:
<deu>, <eng>, <rus>, <lat>, <fin>, <fra>, <it>
