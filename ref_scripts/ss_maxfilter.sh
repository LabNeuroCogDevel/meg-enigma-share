#!/usr/bin/env bash

scriptdir=$(cd $(dirname $0);pwd)
#RAWDIR="/data/Luna1/Multimodal/MEG_RAW"
RAWDIR="/Volumes/Phillips/Raw/MEG/MM"
cd $RAWDIR;

while read s; do
  
  echo $s
  # remove date from name
  ss=${s%_*}

  sdir=/Volumes/Zeus/meg/MMY4/subjs/${ss}
  [ ! -d $sdir ] && mkdir $sdir
  for i in {1..9} ; do 


    inputpatt="/Volumes/Phillips/Raw/MEG/MM/${s}/*/${ss}_Switch_run${i}_*_raw.fif"
    input=$(ls $inputpatt 2>/dev/null)
    [ -z "$input" -o ! -r "$input" ] && echo -e "MISSING RUN $s:$i\n  $inputpatt" && continue


    bcfile=/Volumes/Phillips/Raw/MEG/MM/${s}/1*/${ss}_badchannels_run${i}.txt
    bcpatt="/Volumes/Phillips/Raw/MEG/MM/${s}/1*/${ss}_badchannels_run${i}.txt"
    [ ! -r $bcfile ] && echo -e "missing $s:$i bad channel file:\n  $bcpatt!" && continue
    # get list of bad channels
    bc=$(awk '{printf "%s ",$1}' $bcfile)
    echo "$s:$i bad channels: $bc"

    echo "runnning maxfilter on $ss $i"
    echo "SSS"
    /neuro/bin/util/i686-pc-linux-gnu/maxfilter-2.2 \
            -f $input \
    	-o /Volumes/Zeus/meg/MMY4/subjs/${ss}/${ss}_Switch_run${i}_sss.fif \
            -origin fit -autobad off \
    	-bad ${bc} \
            -st 10 -movecomp inter -v -force \
            >> /Volumes/Zeus/meg/MMY4/subjs/${ss}/${ss}_Switch_run${i}_sss.log
    
    echo "TRANS"
    /neuro/bin/util/i686-pc-linux-gnu/maxfilter-2.2 \
    	-f /Volumes/Zeus/meg/MMY4/subjs/${ss}/${ss}_Switch_run${i}_sss.fif \
    	-o /Volumes/Zeus/meg/MMY4/subjs/${ss}/${ss}_Switch_run${i}_ds_sss.fif \
            -origin fit -trans default -frame head -force -v -autobad off -ds 4 \
            >> /Volumes/Zeus/meg/MMY4/subjs/${ss}/${ss}_Switch_run${i}_trans.log
  done
done < /data/Luna1/Multimodal/Rest_2015_97subjects/AdultSubjectList.txt
