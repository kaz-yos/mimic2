#!/usr/bin/Rscript

### Pick the first occurrence of saturation data for each patients in the target population

## Set working directory
setwd("~/mimic2/")

## Load the HR data extracted in the step before
dataInitial <- read.csv("data_CHARTEVENTS-sat.txt")

## Check dimension
dim(dataInitial)

## Check unique combinations of subject and icu ID
dataInitial <- dataInitial[!duplicated(dataInitial[c("SUBJECT_ID","ICUSTAY_ID")]),
                           c("SUBJECT_ID","ICUSTAY_ID","VALUE1")]
head(dataInitial)


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
dataFinal <- merge(x = dataIcuStayDetail[c("SUBJECT_ID","ICUSTAY_ID")],
                   y = dataInitial,
                   by = c("SUBJECT_ID","ICUSTAY_ID"),
                   all.x = TRUE, all.y = FALSE # left join
                   )

## Change the variable name
names(dataFinal)[3] <- "sat"

## write
write.csv(dataFinal, "data_CHARTEVENTS-sat-first.txt", row.names = F)




















