#!/usr/bin/Rscript

### Pick the first occurrence of heart rate data for each patients in the target population

## Set working directory
setwd("~/mimic2/")

## Load the HR data extracted in the step before
dataHeartRate <- read.csv("data_CHARTEVENTS-HR.txt")

## I just believe it is sorted, and pick the first occurrence.
dataHeartRate <- dataHeartRate[!duplicated(dataHeartRate$SUBJECT_ID),]

## n = 646?? I'll keep it for now.
dim(dataHeartRate)

## write
write.csv(dataHeartRate, "data_CHARTEVENTS-HR-unique.txt")
