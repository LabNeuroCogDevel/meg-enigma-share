# Sharing
revisiting for ENIGMA MEG share. (2023-01-18)

# Acquisiton
Instructions documented in a [word document](https://github.com/LabNeuroCogDevel/meg-enigma-share/raw/main/Multimodal%20Year%202%20MEG%20Instructions.docx)

# Processing?
see [`ref_scripts/`](ref_scripts/). 

Highlights from
`/data/Luna1/Multimodal/Rest_2015_97subjects/scripts/ss_maxfilter.sh`
```
echo "TRANS"
/neuro/bin/util/i686-pc-linux-gnu/maxfilter-2.2 \
	-f /Volumes/Zeus/meg/MMY4/subjs/${ss}/${ss}_Switch_run${i}_sss.fif \
	-o /Volumes/Zeus/meg/MMY4/subjs/${ss}/${ss}_Switch_run${i}_ds_sss.fif \
   -origin fit -trans default -frame head -force -v -autobad off -ds 4 \
    >> /Volumes/Zeus/meg/MMY4/subjs/${ss}/${ss}_Switch_run${i}_trans.log
```

And 
[`maxfilter_rest_wrapper.sh`](https://github.com/LabNeuroCogDevel/allscripts/blob/74ac56b144e35fdc070f3aa94854059ccbb482fc/root/Volumes/T800/Multimodal/Rest_2015_97subjects/scripts/maxfilter_rest_wrapper.sh)
```
RESTDIR="/data/Luna1/Multimodal/Rest_2015_97subjects/subjects"
RAWDIR="/data/Luna1/Multimodal/MEG_Raw"
/neuro/bin/util/i686-pc-linux-gnu/maxfilter-2.2 \
	-f $RESTDIR/${ss}/MEG/${ss}_emptyroom_raw_chpi_sss.fif \
	-o $RESTDIR/${ss}/MEG/${ss}_emptyroom_ds_sss_raw.fif \
	-origin fit -trans default -frame head -force -v -autobad off -ds 4 \
	> $RESTDIR/${ss}/MEG/${ss}_emptyroom_trans.log
```

# Transformation
## fif file header
(20240327)
See `00_findtrans.bash` (using `find_trans.py`; makes [`trans/files_luna1MM.txt`](trans/files_luna1MM.txt) and `trans/log_rest.txt`).

Writes file per rows with columns like  `file`, `hit/partial/miss`, `from`, `to`, `mean(trans)`, `trans_matrix`

where `"hit"` requires `from`=head, `to`=MRI, and `mean(trans)`!=1. "partial" given when `to` and `from` match but trans mat mean is 1. "miss" is all other files (from and to not as wanted).

```
/Volumes/Medusa/Luna1/MM/FS_Subjects/10923_20120119/mri/T1-neuromag/sets/COR-hwangk-120326-110007.fif	hit	head	MRI (surface RAS)	3.9254002512898296 0.9980863332748413 -0.04823729395866394 0.03868649899959564 -0.003494652220979333 0.054638467729091644 0.9809278249740601 -0.1865348219871521 -0.006118252873420715 -0.028950825333595276 0.1882915496826172 0.9816863536834717 -0.043580930680036545 0.0 0.0 0.0 1.0
```

### No from `head` to `MR` for rest?
trans log for MMY4 rest saves to `rest_ds_ss.fif`
```
tail -n1 /Volumes/Zeus/meg/MMY4_rest/subjs/11403/11403_Switch_rest_trans.log
   EXIT OK: Wrote successfully the result to file ... 11403_Switch_rest_ds_sss.fif.
```

but header there is from `MEG deviced` to `head`
```
grep 11403_Switch_rest_sss.fif trans/files*
...11403_Switch_rest_sss.fif       MEG device      head    4.049433422274888 0.9982056021690369 ...
```


### Many COR files?
```
ls /Volumes/Medusa/Luna1/MM/FS_Subjects/11059_20130401/mri/T1-neuromag/sets
COR.fif                      COR-scott-150616-161439.fif
COR-scott-150616-160940.fif  COR-scott-150616-161528.fif
COR-scott-150616-161036.fif  COR-scott-150616-161610.fif
COR-scott-150616-161127.fif  COR-scott-150616-161702.fif
COR-scott-150616-161211.fif  COR-scott-150616-161751.fif
COR-scott-150616-161305.fif  COR-scott-150616-161843.fif
COR-scott-150616-161352.fif  COR-scott-150616-161940.fif
```

`COR.fif` has identity trans matrix. No idea what the other files are. all have file size 6.6Mb.

## log file
Separately, looking at transformation annotated in log file. These go from `device` to `head` (not what we want?)

Like
```
10637_rest_trans	  0.9999  -0.0045   0.0102 !  1.0000   0.0000   0.0000
10637_rest_trans	  0.0047   0.9997  -0.0246 !  0.0000   1.0000   0.0000
10637_rest_trans	 -0.0101   0.0246   0.9996 !  0.0000   0.0000   1.0000
10637_rest_trans	 -0.4250  -2.4821  57.0022 !  1.8484  10.5242  40.2005
10637_rest_trans	Rotation change -0.0, -0.0, -0.0 degrees
10637_rest_trans	Position change (-2.3, -13.0, 16.8) = 21.4 mm
```

Written output fif file is `miss` w/ find trans:
```
grep -i 'EXIT.*.fif' 10637_rest_trans.log # .../MEG/10637_rest_ds_sss_raw.fif
```
(from `MEG device` to `head`)
```
10637_rest_ds_sss_raw.fif   miss    MEG device      head    4.052573025692254 1.0 0.0 0.0 0.001848407555371523 0.0 1.0 0.0 0.01052415743470192 0.0 0.0 1.0 0.04020046070218086 0.0 0.0 0.0 1.0
```
