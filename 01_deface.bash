#!/usr/bin/env bash
#
# deface all t1s for ENGIMA upload
#
# 20230118WF - init
#
source /opt/ni_tools/lncdshell/utils/waitforjobs.sh
export MAXJOBS=10

01_deface_main() {
 [ $# -eq 0 ] && echo "USAGE: $0 [all|ld8_t1.nii.gz]" && exit 1
 [ "$1" == "all" ] &&
    mapfile -t FILES < <(cut -f8 -d' ' MEG_t1-rest-empty_files.txt|sed 1d) ||
    FILES=("$@")

 for t1 in "${FILES[@]}"; do
    ld8=$(ld8 "$t1")
    [ -z "$ld8" ] && warn "no ld8 in $t1" && continue
    out=defaced/${ld8}_t1_deface.nii.gz
    [ -r "$out" ] && continue
    dryrun time pydeface --outfile "$out" "$t1" &
    waitforjobs
 done 
 return 0
}

# if not sourced (testing), run as command
eval "$(iffmain "01_deface_main")"
