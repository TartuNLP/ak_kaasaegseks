#!/bin/bash
# teisenda Asutawa Kogu sõnavormid tänapäevaseks

# 1. tee tokyo-failidest sõnavormide tabel: algne <tab> nyydne
# ei tee uuesti: ./teisenda_sonavara_nyydseks.sh

# 2. tee sõnavormide tabelist muundur aaa.hfstol
# ei tee uuesti: ./teisenda_sonavara_muunduriks.sh

# 3. teisenda tokyo-failides vajalikud read kujule sõnavorm real
# ei tee uuesti: ./tyhik_rvks.py ../tokyo/ ../tokyo_rv


# 4. asenda sõnavormid nyydsetega
# kasutades muundurit
rvkata=../tokyo_rv/
uuskata=../tokyo_nyydne_rv/

if ! [ -d "${uuskata}" ] ; then
    mkdir ${uuskata}
fi

failid=`ls ${rvkata}`

  # sodi mõned sõnad ära, et neid ei teisendataks
  # ja pärast võta sodimine tagasi

for fail in ${failid}
  do
  echo "${fail}"
  cat ${rvkata}/${fail} \
  | sed 's/Kurs-Olesk/Kxurs-Olesk/g' \
  | sed 's/Rätsepp/Rxätsepp/g' \
  | hfst-lookup -q -b 0 aaa.hfstol \
  | grep '.' \
  | gawk -F "\t" '{if ($3 == "inf") {print($1)} else {print($2)}}' \
  | sed 's/Kxurs-Olesk/Kurs-Olesk/g' \
  | sed 's/Rxätsepp/Rätsepp/g' \
  > ${uuskata}/${fail}
  done

# 5. reavahetus tühikuks
./rv_tyhikuks.py ../tokyo_nyydne_rv/ ../tokyo_nyydne



