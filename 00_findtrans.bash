log_trans(){
   # 4 lines of matrix + 2 lines of rotation info
   grep 'Coordinate transformations' -A 6 "$@" |
   # get just the id and rest or empty room part of the matching file
   perl -pe 'next if /^--$/; s;^/.*/([^/]*).log\s*[:-];$1\t;' 
}

scottdir=/Volumes/Medusa/Luna1/Multimodal/Rest_2015_97subjects/subjects/
mmy4dir=/Volumes/Zeus/meg/MMY4/subjs/

mkdir -p trans/

test -r trans/files_luna1MM.txt ||
   ./find_trans.py /Volumes/Medusa/Luna1/MM/ > "$_"

test -r trans/files_luna1MultiModal.txt ||
   ./find_trans.py "$(cd $scottdir/../..; pwd)" > "$_"

test -r trans/files_mmy4.txt ||
   ./find_trans.py "$(cd $mmy4dir/../..; pwd)" > "$_"


test -r trans/log_rest.txt ||
   log_trans $scottdir/*/MEG/*trans.log > "$_"

test -r trans/log_mmy4.txt ||
   log_trans $mmy4dir/1*/*trans.log > "$_"

