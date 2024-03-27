#!/usr/bin/env python3

"""
task has many saccades
rest does not. probably eyes closed

20210211WF (via FC)
"""

import mne
import matplotlib.pyplot as plt

def plot_eog(megin):
    x = mne.io.read_raw_fif(megin)
    try:
        r = x.get_data(['EOG061'])[0]
    except:
        r = x.get_data(['EEG061'])[0]
    plt.plot(r)

def plot_2(rest, task):
    plt.figure()
    #plt.hold(True) # 20230817. deprecated
    plot_eog(rest)
    plot_eog(task)
    plt.show()

rest = './MM/10772_20151021/151021/10772_Switch_rest_raw.fif'
task =  './MM/10772_20151021/151021/10772_Switch_run1_mix1_raw.fif'
plot_2(rest, task)

rest='./MM_Luna1/10772_20130426/130426/10772_WM_rest_raw.fif'
task='./MM_Luna1/10772_20130426/130426/10772_WM_run10_raw.fif'
plot_2(rest, task)
