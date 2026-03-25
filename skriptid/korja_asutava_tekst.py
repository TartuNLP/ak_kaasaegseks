#!/usr/bin/env python3
# kasutamine: ./korja_asutava_tekst.py sisendkataloog väljundfail
# nt. ./korja_asutava_tekst.py ../tokyo/ ../sonavara/asutava_tekst
# võtab kõik sisendkataloogi failid, teeb nendega midagi ja salvestab väljundkataloogi sama nimega

import os
import sys
import xml.etree.ElementTree as ET

kust:str = sys.argv[1]
kuhu:str = sys.argv[2]


def aint_eesti(elem):
    tekst = elem.text or ''
    for alamelem in elem:
        #tekst += aint_eesti(alamelem)
        tekst += '<võõrkeel/>'
        tekst += alamelem.tail or ''
    return tekst


def teisenda_fail(sisendfail:str, väljundfail)->None:

    tree = ET.parse(sisendfail)
    # Get the root element
    root = tree.getroot()

    for h in root.iter('h'):
        väljundfail.write(h.text)
    for spk in root.iter('spk'):
        väljundfail.write(spk.text)
    # Töötle <s> märgendeid
    for s in root.iter('s'):
        # <s> sees jäta vahele: <deu>, <eng>, <rus>, <lat>, <fin>, <fra>, <it>
        lause = aint_eesti(s)
        if lause:
            väljundfail.write(lause + '\n')


def korja_asutava_tekst(kust:str, kuhu:str)->None:

    # vt kõiki faile selles kataloogis
    failid = sorted(os.listdir(kust))
    with open(kuhu,'w') as kuhuf:
        for fail in failid:
            algne = os.path.join(kust, fail)
            print(algne)
            # tee iga failiga mis vaja
            teisenda_fail(algne, kuhuf)


if __name__ == '__main__':
    korja_asutava_tekst(kust, kuhu)


