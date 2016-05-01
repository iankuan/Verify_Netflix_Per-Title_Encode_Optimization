#!/bin/bash
#Program:
#
#History
#2016/4/29 Ken first release

INFILE=${1}

#confirm the file exist or not
echo "file name is $INFILE"

if [ -f $FILENAME ];then
  echo "file exist"
else
  echo "file isn't exist"
  exit 0
fi

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
  temp=$i
  echo "arg $i is ${!i}"
  #IMG_RESOLUTION[$i]=$("$i")
  echo "i is $i"
  i=$(($i+1))
done

FRAMES=128
OUTFILE="reduceVideo.y4m"
#ffmpeg -i $INFILE -ss 00:00:03 -vframes $FRAMES -strict -1 $OUTFILE

#ffmpeg -i $INFILE -vf scale=$IMG_RESOLUTION[] -strict -1 
