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
  	hatanaka_file=$STATION_NAME${dayOfYear}0.${year:2:4}d
    wget --directory-prefix=$OUTPUT_DIR ftp://data-out.unavco.org/pub/rinex/obs/$year/$dayOfYear/${hatanaka_file}.Z
    uncompress ${OUTPUT_DIR}/${hatanaka_file}.Z
    ./CRX2RNX ${OUTPUT_DIR}/$hatanaka_file
  done
done

rm ${OUTPUT_DIR}/${STATION_NAME}*d
./teqc -O.obs L1C1S1 $(ls -v ${OUTPUT_DIR}/${STATION_NAME}*o) > ${OUTPUT_DIR}/${STATION_NAME}${START_YEAR}${START_DAY}_${END_YEAR}${END_DAY}.obs
./rinex2ubx ${OUTPUT_DIR}/${STATION_NAME}${START_YEAR}${START_DAY}_${END_YEAR}${END_DAY}.obs ${OUTPUT_DIR}/${STATION_NAME}${START_YEAR}${START_DAY}_${END_YEAR}${END_DAY}.ubx
