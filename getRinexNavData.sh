#! /bin/bash
# author: Mohamed-Amjad LASRI

while getopts y:Y:d:D:s:o:u option
do
 case "${option}"
 in
 y) START_YEAR=${OPTARG};;
 Y) END_YEAR=${OPTARG};;
 d) START_DAY=${OPTARG};;
 D) END_DAY=${OPTARG};;
 s) STATION_NAME=${OPTARG};;
 o) OUTPUT_DIR=${OPTARG};;
 g) GET_UBX=${OPTARG};;
 *) echo "Usage : ..." ; exit 1 ;;
 esac
done

for year in $(seq $START_YEAR $END_YEAR)
do
  for dayOfYear in $(seq -w $START_DAY $END_DAY)
  do
  	hatanaka_file=$STATION_NAME${dayOfYear}0.${year:2:4}n
    wget --directory-prefix=$OUTPUT_DIR ftp://rgpdata.ign.fr/pub/data/$year/$dayOfYear/data_30/${hatanaka_file}.Z
    uncompress ${OUTPUT_DIR}/${hatanaka_file}.Z
  done
done

#rm ${OUTPUT_DIR}/${STATION_NAME}*n
#./teqc $(ls -v ${OUTPUT_DIR}/${STATION_NAME}*n) > ${OUTPUT_DIR}/${STATION_NAME}${START_YEAR}${START_DAY}_${END_YEAR}${END_DAY}.nav
