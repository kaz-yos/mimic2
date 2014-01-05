### Overview script to explain the steps


### Extract IDs for MICU patients with top 10% SAPS score (>20)
## source("01.patient.extraction.R")
## IDs saved as ~/statistics/mimic2/subject_ids.csv


### Extract heart rate data for these patients
## $ python3 ./02.patient.hr.extraction.py
## Saved as ~/mimic2/data_CHARTEVENTS-HR.txt


### Remove duplicates and get the first occurrence only
## source("./03.patient.hr.first.occurence.R")
## Saved as ~/mimic2/data_CHARTEVENTS-HR-unique.txt


### Extract ventilater related data for the same patients
## $ python3 ./04.patient.vent.extraction.py
