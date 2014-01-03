### Test analysis script in Python3

## Import libraries
import os
import pandas as pd

## Change to the data folder
os.chdir("/Users/kazuki/mimic2")

## Load files
data_note_events = pd.read_csv("data_NOTEEVENTS-merge_final.txt")

print(data_note_events.ix[1,"TEXT"])
