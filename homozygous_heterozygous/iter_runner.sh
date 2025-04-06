for iter in {1..1000}
do
for shuf in 1000 2000 4000 8000 10000 12000
do
for data in SRR17981950_51_52_Fm_locus_merged.bed SRR17968711_12_CAU_Silkie_Fm_subseted.bed SRR27781695_96_97_merged.bed
do
D1=`cat $data|shuf -n $shuf|bedtools intersect -a regions.bed -b stdin -wao|grep "DUP1"|awk '{sum += $12} END {print sum/127379}'`
D2=`cat $data|shuf -n $shuf|bedtools intersect -a regions.bed -b stdin -wao|grep "DUP2"|awk '{sum += $12} END {print sum/170815}'`
IN=`cat $data|shuf -n $shuf|bedtools intersect -a regions.bed -b stdin -wao|grep "INT"|awk '{sum += $12} END {print sum/412535}'`
echo $iter $D1 $D2 $IN $shuf $data|awk '{print $0,$2/$4,$3/$4}'
done
done
done
