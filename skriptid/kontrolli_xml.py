#!/usr/bin/env python3
# kasutamine: ./kontrolli_xml.py xml-fail
# kontrollib xml-i korrektsust; vea korral trükib välja faili nime ja vigase rea

import sys
import xml.etree.ElementTree as ET
from xml.etree.ElementTree import ParseError
import traceback

def kontrolli(algne:str)->None:

    with open(algne, "r", encoding="utf-8-sig") as f:
            xml_text = f.read()
    try:
        root = ET.fromstring(xml_text)
    except ParseError as pe:
        print('vigane XML: ', algne)
        #print(traceback.format_exc())
        # Get location of parsing error
        err_line, err_col = pe.position
        xml_text_lines = xml_text.split('\n')
        print(f'vigane rida: ', xml_text_lines[err_line-1])
        print()
        return None


if __name__ == '__main__':
    for algne in sys.argv[1:]:
        kontrolli(algne)

