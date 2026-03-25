#!/usr/bin/env python3
# kasutamine: ./paranda_asutavat_kogu.py sisendkataloog väljundkataloog
# nt. ./paranda_asutavat_kogu.py ../tokyo/ ../uus_tokyo
# võtab kõik sisendkataloogi failid, teeb nendega midagi ja salvestab väljundkataloogi sama nimega

import os
import re
import sys
import xml.etree.ElementTree as ET

kust:str = sys.argv[1]
kuhu:str = sys.argv[2]

def teisenda_fail(sisendfail:str, väljundfail:str)->None:

    tree = ET.parse(sisendfail)
    # Get the root element
    root = tree.getroot()

    keelesilt = {'deu', 'eng', 'rus', 'lat', 'fin', 'fra', 'it'}
    # Töötle <s> märgendeid
    for s in root.iter('s'):
        if s.text is not None:
            # <s> sees jäta vahele: <deu>, <eng>, <rus>, <lat>, <fin>, <fra>, <it>
            algtxt:str = s.text
            uustxt:str = re.sub("([abcdefghijklmnopqrstuvwxyzäöõüžš])([;:,\.?!\)]+)([\(§ABCDEFGHIJKLMNOPQRSTUVWXYZÕÄÖÜŽŠabcdefghijklmnopqrstuvwxyzäöõü])",
                               r"\1\2 \3", algtxt)  # parandab selleks,et --> selleks, et
            uust:str = re.sub("([abcdefghijklmnopqrstuvwxyzäöõüžš])([(]+)([§ABCDEFGHIJKLMNOPQRSTUVWXYZÕÄÖÜŽŠabcdefghijklmnopqrstuvwxyzäöõü])",
                               r"\1 \2\3", uustxt)  # parandab selleks(et --> selleks (et
            s.text = uust
            for alamelem in s:
                if alamelem.tag not in keelesilt:
                    if alamelem.text is not None:
                        alamelem.text = alamelem.text.replace('a', 'a') # ei tee midagi
        
#---
    # Salvesta muudetud XML uude faili
    tree.write(väljundfail, encoding='utf-8', xml_declaration=True)

def teisenda_xml_kataloog(kust:str, kuhu:str)->None:
    # sihtkataloog olgu olemas
    failid = sorted(os.listdir(kust))
    os.makedirs(kuhu, exist_ok=True)

    # vt kõiki faile selles kataloogis
    for fail in failid:
        algne = os.path.join(kust, fail)
        siht = os.path.join(kuhu, fail)
        print(algne)

        # tee iga failiga mis vaja
        teisenda_fail(algne, siht)


if __name__ == '__main__':
    teisenda_xml_kataloog(kust, kuhu)


