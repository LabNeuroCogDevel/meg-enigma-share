#!/usr/bin/env bash
exit 1 # only needed to do once. here as documentation
# pip install globus; globus login; globus whoami # =foran@pitt.edu

#globus endpoint search "UPMC_BL_MEG"
#ID                                   | Owner           | Display Name
#------------------------------------ | --------------- | ------------
#441d5764-ad50-11ed-adff-bfc1a406350a | stoutjd@nih.gov | UPMC_BL_MEG

# /Volumes/Hera/Projects/Globus/globusconnectpersonal-3.2.0/globusconnectpersonal -trace -restrict-paths r/Volumes/,r/data/Luna1  -start

# symlinks need to be expliclty marked. need batch.
# defaced would trasfer like
#globus transfer -r $(globus endpoint local-id):/Volumes/Phillips/Raw/MEG/defaced 441d5764-ad50-11ed-adff-bfc1a406350a:/
find defaced/ meg/ -type f,l| while read f; do echo "$f $(echo $f|ld8)/$(basename $f)"; done > globus_batch.txt
globus transfer --batch ./globus_batch.txt $(globus endpoint local-id):/Volumes/Phillips/Raw/MEG/ 441d5764-ad50-11ed-adff-bfc1a406350a:/
globus transfer $(globus endpoint local-id):/Volumes/Phillips/Raw/MEG/MEG_t1-rest-empty_files.txt 441d5764-ad50-11ed-adff-bfc1a406350a:MEG_t1-rest-empty_files.txt
