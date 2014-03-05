### Extract the heart rate data from the target population (n = 663)

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

## Check presence of IDs
31493 in subject_ids    # Should be True
31494 in subject_ids    # Should be False


## Open the files
chart_events = open(os.path.expanduser("~/mimic2/data_CHARTEVENTS-merge_final.txt"), mode = "r")
chart_events2 = open(os.path.expanduser("~/mimic2/data_CHARTEVENTS-HR.txt"), mode = "w")

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

        ## Pick 211 (HR) and subjects of interest
        if int(line_split[2]) == 211 and int(line_split[0]) in subject_ids:
            ## Write to a new file
            chart_events2.write(line)
            print("Wrote ", line)
        else:
            ## Otherwise do nothing and pass
            pass

chart_events.close()            
chart_events2.close()

## Then delete the duplicates (easier in R)
