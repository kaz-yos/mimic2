#!/usr/bin/Rscript

### Pick the first occurrence of heart rate data for each patients in the target population

## Set working directory
setwd("~/mimic2/")

## Load the HR data extracted in the step before
dataVentilator <- read.csv("data_CHARTEVENTS-vent.txt")

## Check dimension
dim(dataVentilator)
## [1] 254851     16

## Check unique combinations of subject and icu ID
dataVentilatorUniquePtIcu <- unique(dataVentilator[c("SUBJECT_ID","ICUSTAY_ID")])
head(dataVentilatorUniquePtIcu)

## Add ventilator indicator
## dataVentilatorUniquePtIcu$vent = "Y"
dataVentilatorUniquePtIcu$vent <- 1


## Subject IDs of ventilator users
## subjectIdsOfVentilatorUsers <- unique(dataVentilator$SUBJECT_ID)

## Create a use indicator DF
## subjectIdsOfVentilatorUsers <- data.frame(SUBJECT_ID = subjectIdsOfVentilatorUsers, vent = "Yes")

## ## Load the 663 IDs as a data frame
## subjectIds <- read.csv("~/statistics/mimic2/subject_ids.csv")

## Load ICU stay detail (most important) 2014-01-05
dataIcuStayDetail <- read.csv("~/mimic2/data_ICUSTAY_DETAIL-merge_final.txt")
## n = 497
dataIcuStayDetail <- subset(dataIcuStayDetail,
                            !is.na(SAPSI_FIRST) &
                            SAPSI_FIRST > 20 &
                            ICUSTAY_FIRST_FLG == "Y" &
                            HOSPITAL_FIRST_FLG == "Y" &
                            ICUSTAY_FIRST_CAREUNIT == "MICU"
                            )

## Merge to these people
dfVentUseIndicator <- merge(x = dataIcuStayDetail[c("SUBJECT_ID","ICUSTAY_ID")],
                            y = dataVentilatorUniquePtIcu,
                            by = c("SUBJECT_ID","ICUSTAY_ID"),
                            all.x = TRUE, all.y = FALSE # left join
                            )

## Merge
## dfVentUseIndicator <- merge(x = subjectIdsOfVentilatorUsers,
##                             y = subjectIds,
##                             all.x = TRUE, all.y = TRUE # outer join
##                             )

## Convert a character vector
dfVentUseIndicator$vent <- as.character(dfVentUseIndicator$vent)

## NA's are No
## dfVentUseIndicator$vent[is.na(dfVentUseIndicator$vent)] <- "No"
dfVentUseIndicator$vent[is.na(dfVentUseIndicator$vent)] <- 0

## Summary
table(dfVentUseIndicator$vent)

## write
write.csv(dfVentUseIndicator[c("SUBJECT_ID","vent")], "data_CHARTEVENTS-vent-use.txt", row.names = F)
