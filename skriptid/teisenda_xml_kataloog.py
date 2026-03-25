#!/usr/bin/env python3
# kasutamine: ./teisenda_xml_kataloog.py sisendkataloog väljundkataloog
# nt. ./teisenda_xml_kataloog.py ../tokyo/ ../uus_tokyo
# võtab kõik sisendkataloogi failid, teeb nendega midagi ja salvestab väljundkataloogi sama nimega

import os
import sys
import xml.etree.ElementTree as ET

kust:str = sys.argv[1]
kuhu:str = sys.argv[2]

def teisenda_fail(sisendfail:str, väljundfail:str)->None:
    tree = ET.parse(sisendfail)
    # Get the root element

    # tee mis vaja
    '''
    root = tree.getroot()

    # Töötle <s> märgendeid
    for s in root.iter('s'):
        if s.text:
            s.text = s.text.replace(' ', '\n')
    for h in root.iter('h'):
        if h.text:
            h.text = h.text.replace(' ', '\n')
    '''
    # Salvesta muudetud XML uude faili
    tree.write(väljundfail, encoding='utf-8', xml_declaration=True)

def teisenda_xml_kataloog(kust:str, kuhu:str)->None:
    # sihtkataloog olgu olemas
    os.makedirs(kuhu, exist_ok=True)

    # vt kõiki faile selles kataloogis
    for fail in os.listdir(kust):
        algne = os.path.join(kust, fail)
        siht = os.path.join(kuhu, fail)
        print(algne)

        # tee iga failiga mis vaja
        teisenda_fail(algne, siht)


if __name__ == '__main__':
    teisenda_xml_kataloog(kust, kuhu)


