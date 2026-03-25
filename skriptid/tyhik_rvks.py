#!/usr/bin/env python3
# kasutamine: ./tyhik_rvks.py sisendkataloog väljundkataloog
# nt. ./tyhik_rvks.py ../tokyo/ ../tokyo_rv
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

    # Töötle <h> sisu
    for h in root.iter('h'):
        if h.text is not None:
            uustx:str = h.text.replace(' ', '\n')
            h.text = uustx
    # Töötle <spk> sisu
    for spk in root.iter('spk'):
        if spk.text is not None:
            uustx:str = spk.text.replace(' ', '\n')
            spk.text = uustx

    # <s> sees jäta vahele: <deu>, <eng>, <rus>, <lat>, <fin>, <fra>, <it>
    keelesilt = {'deu', 'eng', 'rus', 'lat', 'fin', 'fra', 'it'}
    # Töötle <s> sisu
    for s in root.iter('s'):
        if s.text is not None:
            uustx:str = s.text.replace(' ', '\n')
            s.text = uustx
            # eeldan, et alamelemendil omakorda pole alamelemente
            for alamelem in s:
                if alamelem.text is not None: 
                    if alamelem.tag in keelesilt:
                        pass
                    else:      # on miski muu kui võõrkeelne text
                        alamelem.text = alamelem.text.replace(' ', '\n')  
                if alamelem.tail is not None: 
                    # see töötab õigesti ainult eeldusel, et pole alam-alamelemente
                    alamelem.tail = alamelem.tail.replace(' ', '\n') # 

        
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


