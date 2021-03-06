#!/usr/local/bin/python3

### Extract ventilator related data from the data_CHARTEVENTS-merge_final.txt file

## Import libraries
import os
import numpy as np
import pandas as pd

## Set directory
os.chdir(os.path.expanduser("~/statistics/mimic2"))

## Make an array of IDs for whom we extract the HR data
subject_ids = pd.read_csv("./subject_ids.csv")
subject_ids = np.array(subject_ids.SUBJECT_ID)
type(subject_ids)

## Make an array of item ids to extract
## http://mimic.physionet.org/UserGuide/node83.html
# 6.2.23 Ventilators
# ITEMID  LABEL      CATEGORY
# ---------------------------
# 505     peep              [value1num]
# 506     peep              [value1num]
# 535     PeakInspPressure  [value1num]
# 543     PlateauPressure   [value1num]
# 544     Plateau Time (7200)
# 545     Plateau-Off
# 619     Respiratory Rate Set
#  39     Airway Size
# 535     Peak Insp. Pressure
# 683     Tidal Volume (Set)
# 720     Ventilator Mode
# 721     Ventilator No.
# 722     Ventilator Type
# 732     Waveform-Vent
item_ids = np.array([505,506,535,543,544,545,619, 39,535,683,720,721,722,732])


## Open the files
chart_events = open(os.path.expanduser("~/mimic2/data_CHARTEVENTS-merge_final.txt"), mode = "r")
chart_events2 = open(os.path.expanduser("~/mimic2/data_CHARTEVENTS-vent.txt"), mode = "w")

## Line by line pick up

## Get the header line
header_chart_events = chart_events.readline()

## Write the header to the output file
chart_events2.write(header_chart_events)

## Loop for each line   (20GB file. Takes a while)
while True:
    line = chart_events.readline()
    ## print(line)
    if line == "":
        ## break at the EOF
        break
    else:
        line_split = line.split(sep = ",")

        ## Pick ventilator related variables and subjects of interest
        if int(line_split[2]) in item_ids and int(line_split[0]) in subject_ids:
            ## Write to a new file
            chart_events2.write(line)
            print("Wrote ", line)
        else:
            ## Otherwise do nothing and pass
            pass

chart_events.close()            
chart_events2.close()

## Then delete the duplicates (easier in R)

