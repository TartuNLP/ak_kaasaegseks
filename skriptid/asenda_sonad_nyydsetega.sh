#!/bin/bash
# kasutamine: ./asenda_sonad_nyydsetega.sh alg_kata tulem_kata
# asenda sõnavormid nyydsetega
# kasutades varemtehtud muundurit aaa.hfstol

rvkata=$1
uuskata=$2

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




