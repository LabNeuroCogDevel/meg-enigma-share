#!/usr/bin/env bash
#
# link all MEG data
#
# 20230223WF - init
#

ln_one(){
   infile="$(readlink -f "$1")"; shift
   [ ! -r "$infile" ] && warn "# not readable $1->'$infile'" && return 1
   ld8=$(ld8 "$infile"|sed 1q)
   [ -z "$ld8" ] && warn "# no ld8 in $infile" && return 2
   sdir="meg/$ld8"
   mkdir -p "$sdir"
   [ -r "$sdir/$(basename "$infile")" ] ||
      ln -s "$infile" "$sdir/"
}

ln_main() {
 [ $# -eq 0 ] && echo "USAGE: $0 [all|file.fif]" && exit 1
 [ "$1" == "all" ] &&
    mapfile -t FILES < <(cut -f3,4 -d' ' MEG_t1-rest-empty_files.txt|sed 1d|sed 's/ /\n/') ||
    FILES=("$@")

 export -f ln_one
 for meg in "${FILES[@]}"; do
    dryrun ln_one "$meg" || :
 done 
 return 0
}

# if not sourced (testing), run as command
eval "$(iffmain "ln_main")"
