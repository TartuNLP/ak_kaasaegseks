#!/bin/bash
# teisenda Asutawa Kogu sõnavormid tänapäevaseks

# 1. tee tokyo-failidest sõnavormide tabel: algne <tab> nyydne
./teisenda_sonavara_nyydseks.sh

# 2. tee sõnavormide tabelist muundur aaa.hfstol
./teisenda_sonavara_muunduriks.sh

# 3. teisenda tokyo-failides vajalikud read kujule sõnavorm real
./tyhik_rvks.py ../tokyo/ ../tokyo_rv


# 4. asenda sõnavormid nyydsetega
# kasutades muundurit aaa.hfstol

./asenda_sonad_nyydsetega.sh ../tokyo_rv ../tokyo_nyydne_rv

# 5. reavahetus tühikuks
./rv_tyhikuks.py ../tokyo_nyydne_rv ../tokyo_nyydne



