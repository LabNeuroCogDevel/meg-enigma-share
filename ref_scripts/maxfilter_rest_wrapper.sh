# run maxfilter and ICA denoising on subs with bad channel text files 
RESTDIR="/data/Luna1/Multimodal/Rest_2015_97subjects/subjects"
scriptdir=$(cd $(dirname $0);pwd)
RAWDIR="/data/Luna1/Multimodal/MEG_Raw"
# For each subject
cd $RESTDIR;

while read s; do 
echo "subj $s" 

        while [ `jobs | wc -l` -ge 8 ]
        do
                sleep 10
        done


ss=${s%_*} # remove trailing /
echo "$ss"
# do we need to do anything?
#numICA=$(ls $RESTDIR/${s}/MEG/${ss}_rest_ds_sss_raw.fif 2>/dev/null|wc -l )
#[ $numICA -eq 8 ] && echo "already have maxfilter and ICA for $s" && continue

#echo "Extract bad channels from text files"

#perl -lne 'print $1 if /(\d{4})/' $RESTDIR/badchannels/${ss}_badchannels_Rest > $RESTDIR/badchannels/BC_rest_shortened/${ss}_BCrest 
#echo "done BC"
#finalfile=$RESTDIR/${s}/MEG/${ss}_rest_ds_sss_raw.fif

# skip if we've already done
#[ -r "$finalfile" ] && echo "already did $s:$r" && continue
# skip if we don't have the text file
#[ ! -r "$BCrest" ] && echo "missing $s:$r txt file" && continue
bc=$(awk '{printf "%s ",$0}' /data/Luna1/Multimodal/MEG_Raw/${s}/*/${ss}_badchannels_emptyroom.txt)
echo "$bc"
echo "runnning maxfilter on $ss"
/neuro/bin/util/i686-pc-linux-gnu/maxfilter-2.2 \
	-f $RAWDIR/${s}/*/${ss}_*_emptyroom_raw.fif \
	-o $RESTDIR/${ss}/MEG/${ss}_emptyroom_raw_chpi_sss.fif \
	-origin fit -autobad off \
	-bad $bc \
	-st 10 -movecomp inter -v -force \
	> $RESTDIR/${ss}/MEG/${ss}_emptyroom_raw_sss.log

/neuro/bin/util/i686-pc-linux-gnu/maxfilter-2.2 \
	-f $RESTDIR/${ss}/MEG/${ss}_emptyroom_raw_chpi_sss.fif \
	-o $RESTDIR/${ss}/MEG/${ss}_emptyroom_ds_sss_raw.fif \
	-origin fit -trans default -frame head -force -v -autobad off -ds 4 \
	> $RESTDIR/${ss}/MEG/${ss}_emptyroom_trans.log
echo "$ss complete"

done < /data/Luna1/Multimodal/Rest_2015_97subjects/scripts/subjlist20150430.txt
