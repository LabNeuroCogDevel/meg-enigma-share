#!/usr/bin/env python3
"""
parse fif header for from,to, and trans mat
adapted from Jeff's code forwarded by AN

20240326WF
"""
import sys, mne, glob, os, os.path as op
import numpy as np
def mat_str(mat):
    tot = np.sum(mat)
    return str(tot) + " " + \
            " ".join([str(x) for x in mat.flatten().tolist()])

# does pregenerating save any time?
eye = np.eye(4)
zero4 = np.zeros(4)

# mock mne trans mat object. for when read_trans fails
mock_trans = type("mock",(), dict(from_str='NA',to_str='NA'))
mock_trans.get = lambda _: zero4 

def get_trans(fif):
    """ return dict of fif and trans or None"""
    try:
        trans = mne.read_trans(fif)
    except Exception as e:
        trans = mock_trans
    hit = "miss"
    if trans.from_str == 'head' and 'MRI':
        hit = "partial"
        if not np.all(eye==trans.get('trans')):
            hit = "hit"

    trans_info = [fif,hit,trans.from_str, trans.to_str, trans.get('trans')]
    print(("\t".join(trans_info[0:4])) + "\t" + mat_str(trans_info[4]))
    return trans_info

def trans_at_dir(root_dir):
    """ search through root_dir """
    fif_files=glob.glob(op.join(root_dir, '**/*.fif'), recursive=True, root_dir=root_dir)
    trans_info = [get_trans(f) for f in fif_files]
    return trans_info

if __name__ == "__main__":
    trans_at_dir(sys.argv[1])
