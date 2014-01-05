### Test analysis script in Python3

## Import libraries
import os
import pandas as pd

## Change to the data folder
os.chdir("/Users/kazuki/mimic2")

## Load files (2GB)
data_note_events = pd.read_csv("data_NOTEEVENTS-merge_final.txt")

## print(data_note_events.ix[0,"TEXT"])
print(data_note_events.ix[1,"TEXT"])
print(data_note_events.ix[2,"TEXT"])
print(data_note_events.ix[3,"TEXT"])
data_note_events.ix[3,]

## 
data_census_events = pd.read_csv("data_CENSUSEVENTS-merge_final.txt")
data_census_events

data_census_events.ix["DISCHARGESTATUS"]


