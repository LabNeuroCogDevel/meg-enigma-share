#!/usr/bin/env python3
from glob import glob
import mne
import seaborn


def readdur(f):
     x = mne.io.read_raw_fif(f)
     return x.n_times/x.info['sfreq']

allf = glob('./*/1*_2*/*/1*_rest_raw.fif')
durs = [readdur(x) for x in allf]

seaborn.histplot(durs)
