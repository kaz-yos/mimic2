### Extract patients

## Load ICU stay detail (most important)
dataIcuStayDetail <- read.csv("~/mimic2/data_ICUSTAY_DETAIL-merge_final.txt")
table(dataIcuStayDetail$ICUSTAY_FIRST_CAREUNIT)

## subset to MICU patients with 
dataIcuStayDetail <- subset(dataIcuStayDetail,
                            ICUSTAY_FIRST_CAREUNIT == "MICU" &
                            !is.na(SAPSI_FIRST) & 
                            SAPSI_FIRST > 20
                            )

## n = 663
dim(dataIcuStayDetail)

## Subject IDs for those who we want
subjectIds <- dataIcuStayDetail$SUBJECT_ID
length(subjectIds)

## Make a data frame
subjectDataframe <- data.frame(SUBJECT_ID = subjectIds)

## Write to a file
write.csv(subjectDataframe, file = "subject_ids.csv")



















