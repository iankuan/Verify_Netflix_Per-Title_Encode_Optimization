#!/bin/bash
#Program:
#
#History
#2016/4/29 Ken first release

INFILE=${1}

###confirm the file exist or not
echo "file name is $INFILE"

if [ -f $FILENAME ];then
  echo "file exist"
else
  echo "file isn't exist"
  exit 0
fi

###Get the resolution from argument

echo "argument number $#"
echo $@
numARG=$#
#i=1
i=2
#set -- $@
#echo ${!i}

#while [ $i -le $(($#-2)) ]
while [ $i -le $# ]
do
  #temp=$i
  echo "arg $i is ${!i}"
  IMG_RESOLUTION[$(($i-1))]=${!i}
  #echo "i is $i"
  i=$(($i+1))
done

##Reduce Frame argument
RF_FILE=reduceFrame.y4m
START=00:00:03
FRAMES=128

##Down Sampling argument
DS_FILE=downSampling.y4m

##Encode HEVC argument
#QP is 0~51
read -p "please input the step size of QP" step
j=0
k=1
while [ $j -le 51 ]
do
  QP[$k]=$j
  echo "new QP $j class"
  k=$(($k+1))
  j=$(($j+$step))
done

##Decode HEVC argument
DC_FILE=decode.y4m

##Up Sampling argument
US_FILE=upSampling.y4m

##Calculate PSNR argument
PSNR_LOG=PSNR.log

###Reduce Frame
START=00:00:03
ffmpeg -i $INFILE -ss $START -vframes $FRAMES -strict -1 $RF_FILE

read -p "pause" Pause
l=1
#TODO:BUG for loop condition
while [ $l -lt $(($i-1)) ]
do
  TEMPDS=${IMG_RESOLUTION[$l]}_$DS_FILE
###Down Sampling
  ffmpeg -i $RF_FILE -vf scale=${IMG_RESOLUTION[$l]} -strict -1 $TEMPDS
###Encode HEVC
  S=1
  while [ $S -lt $k ]
  do
    TEMPQPBIN=${IMG_RESOLUTION[$l]}_${QP[$S]}.bin
    TEMPCSV=${IMG_RESOLUTION[$l]}_${QP[$S]}.csv
    x265 $TEMPDS $TEMPQPBIN -p slower -q ${QP[$S]} --csv-log-level 2 --csv $TEMPCSV --tune psnr

###Decode HEVC
    TEMPDC=${IMG_RESOLUTION[$l]}_${QP[$S]}_$DC_FILE
    ffmpeg -i $TEMPQPBIN -vsync 0 -strict -1 $TEMPDC
###Up Sampling
    TEMPUS=${IMG_RESOLUTION[$l]}_${QP[$S]}_$US_FILE
    ffmpeg -i $TEMPDC -vf scale=4096x2160 -strict -1 $TEMPUS
###Calulate PSNR
    TEMPLOG=${IMG_RESOLUTION[$l]}_${QP[$S]}_$PSNR_LOG
    ffmpeg -i $RF_FILE -i $TEMPUS -filter_complex "psnr" -f null nul > $TEMPLOG 2>&1
###TODO:get PSNR and Bitrate

    echo "CSV $TEMPCSV LOG $TEMPLOG"
    echo "grep -A1 "'$TEMPCSV'" $TEMPCSV | awk -F', ' '{print $5}'"
    Bitrate=$(grep -A1 $TEMPCSV $TEMPCSV | awk -F', ' '{print $5}')
    echo "Bit $Bitrate"
    PSNR=$(grep -oP 'PSNR y:\K\d+.\d+' $TEMPLOG)
    echo "PSNR $PSNR"
    echo "Bitrate $Bitrate PSNR $PSNR"
    echo "$Bitrate $PSNR" >> ${IMG_RESOLUTION[$l]}_Bitrate_PSNR.log
    S=$(($S+1))
  done
  FILEINGP[$l]=${IMG_RESOLUTION[$l]}_Bitrate_PSNR.log
  echo "GILEINGP[$l] ${FILEINGP[$l]}"
  l=$(($l+1))
done


GPCONFIG=gpconfig.gp
GPPLOT="plot [0:30000][20:55] "
p=1
echo "***** l = $l*****"
while [ $p -lt $l ]
do
  GPPLOT="$GPPLOT ""'${FILEINGP[$p]}'"" title ""'${IMG_RESOLUTION[$p]}'"","
  echo "p = $p ,l = $l"
  p=$(($p+1))
done

echo "GPPLOT $GPPLOT"

echo $GPPLOT
TEMPGP=tempgp.gp
cp gpconfig.gp $TEMPGP
echo $GPPLOT >> $TEMPGP

gnuplot $TEMPGP

rm -f $TEMPGP

#ffmpeg -i $INFILE -vf scale=$IMG_RESOLUTION[] -strict -1

###get PSNR
#grep -oP 'PSNR y:\K\d+.\d+' psnr.log
###get Bitrate
#grep -A1 '1024x540_0.csv' 1024x540_0.csv | awk -F', ' '{print $5}'
#echo $TESTGP | gnuplot ###work!!!
#multiple execution will cause csv file to append , so the grep will get multiple result Fxxk
