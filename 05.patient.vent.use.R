#!/usr/bin/Rscript

### Pick the first occurrence of heart rate data for each patients in the target population

## Set working directory
setwd("~/mimic2/")

## Load the HR data extracted in the step before
dataVentilator <- read.csv("data_CHARTEVENTS-vent.txt")

## Check dimension
dim(dataVentilator)
## [1] 254851     16

## Check unique patients
length(unique(dataVentilator$SUBJECT_ID))
## n = 581. Not every one of 663 people used ventilators.

## If none of these variables are present, safe to assume the patient was never on ventilator.
## http://mimic.physionet.org/UserGuide/node83.html
## 6.2.23 Ventilators
## ITEMID  LABEL      CATEGORY
## ---------------------------
## 505     peep              [value1num]
## 506     peep              [value1num]
## 535     PeakInspPressure  [value1num]
## 543     PlateauPressure   [value1num]
## 544     Plateau Time (7200)
## 545     Plateau-Off
## 619     Respiratory Rate Set
##  39     Airway Size
## 535     Peak Insp. Pressure
## 683     Tidal Volume (Set)
## 720     Ventilator Mode
## 721     Ventilator No.
## 722     Ventilator Type
## 732     Waveform-Vent

## Subject IDs of ventilator users
subjectIdsOfVentilatorUsers <- unique(dataVentilator$SUBJECT_ID)

## Create a use indicator DF
subjectIdsOfVentilatorUsers <- data.frame(SUBJECT_ID = subjectIdsOfVentilatorUsers, vent = "Yes")

## Load the 663 IDs as a data frame
subjectIds <- read.csv("~/statistics/mimic2/subject_ids.csv")

## Merge
dfVentUseIndicator <- merge(x = subjectIdsOfVentilatorUsers,
                            y = subjectIds,
                            all.x = TRUE, all.y = TRUE # outer join
                            )

## Convert a character vector
dfVentUseIndicator$vent <- as.character(dfVentUseIndicator$vent)

## NA's are No
dfVentUseIndicator$vent[is.na(dfVentUseIndicator$vent)] <- "No"

## Summary
table(dfVentUseIndicator$vent)

## write
write.csv(dfVentUseIndicator[c("SUBJECT_ID","vent")], "data_CHARTEVENTS-vent-use.txt", row.names = F)
