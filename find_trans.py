#!/usr/bin/env python3
import sys, mne, glob, os, os.path as op
import numpy as np
def mat_str(mat):
    tot = np.sum(mat)
    return str(tot) + " " + \
            " ".join([str(x) for x in mat.flatten().tolist()])
eye = np.eye(4)
mock_trans = type("mock",(), dict(from_str='NA',to_str='NA'))
mock_trans.get = lambda _: np.zeros(4)

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
