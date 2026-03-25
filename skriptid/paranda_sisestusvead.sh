#!/bin/sh


# kasuta viga@korras paare korpuse parandamiseks

alg=../alg_tokyo/
tulem=../tokyo
parandusfail=../sonavara/viga_korras.tab

# tee tulemkataloog
if ! [ -d "${tulem}" ] ;
then
    mkdir ${tulem}
fi

# las eraldajaks olla @, siis on awkiga parem askeldada
cat ${parandusfail} | tr '\t' '@' > tmp_para

# 2. paranda protokolle ja pane failid uude kataloogi
# selleks peab m.h. panema tühikud ja need pärast ära kustutama

for file in `ls ${alg}/`
    do
    echo ${file} 
    # esialgne pisipuhastus
    cat ${alg}/${file} | sed 's/\r//g' | sed 's/\^//' > tmp1
    
    # tee uus sõnestus, lisades tühikuid (ja pea meeles, kuhu lisasid)
    cat tmp1 \
    | sed 's/\([01234567890\.,:;?!"()“”„§\/+#=%½¶¹°˚…＿£—–_«»}\*\-]\)\([[:alpha:]]\)/\1<tyhikpar> \2/g' \
    | sed 's/\([[:alpha:]]\)\([01234567890\.,:;?!"()“”„§\/+#=%½¶¹°˚…＿£—–_«»}\*\-]\)/\1 <tyhikvas>\2/g' \
    > tmp2
    
    # paranda sõnu
    cat tmp_para tmp2 \
    | gawk -F@ 'NF==2 {tab[$1]=$2}; NF==1 {n=split($0, s, " "); for (i=1; i<=n; i++) {if (s[i] in tab) s[i]=tab[s[i]];} v=s[1]; for (i=2; i<=n; i++) v=v " " s[i]; print v}' > tmp3

    # taasta algne sõnestus
    cat tmp3 | sed 's/<tyhikpar> //g' | sed 's/ <tyhikvas>//g' > ${tulem}/${file}
    done



