#!/usr/bin/Rscript

### Pick the first occurrence of heart rate data for each patients in the target population

## Set working directory
setwd("~/mimic2/")

## Load the HR data extracted in the step before
dataHeartRate <- read.csv("data_CHARTEVENTS-HR.txt")
unique(dataHeartRate[c("SUBJECT_ID","ICUSTAY_ID")])

## 193064
dim(dataHeartRate)


## Got the first for each subject/icu stay id
## dataHeartRate <- dataHeartRate[!duplicated(dataHeartRate$SUBJECT_ID),]
dataHeartRate <- dataHeartRate[!duplicated(dataHeartRate[c("SUBJECT_ID","ICUSTAY_ID")]),]

## 1264
dim(dataHeartRate)


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
dataHeartRateFinal <- merge(x = dataIcuStayDetail[c("SUBJECT_ID","ICUSTAY_ID")],
                            y = dataHeartRate[c("SUBJECT_ID","ICUSTAY_ID","VALUE1")],
                            by = c("SUBJECT_ID","ICUSTAY_ID"),
                            all.x = TRUE, all.y = FALSE # left join
                            )

## Give HR
names(dataHeartRateFinal)[3] <- "HR"

## write
write.csv(dataHeartRateFinal, "data_CHARTEVENTS-HR-unique.txt", row.names = F)
















