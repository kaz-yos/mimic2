### Test script

## Memo
## Looking for codes for coded items
## select * from D_codeditems where itemid = 70063

## Set directory
mimicDataDir <- "~/mimic2/"

## List files
dataFiles <- dir(pattern = "data_")

## Add preceding path
dataFiles <- paste0(mimicDataDir, dataFiles)


## Load ICD9 file
dataIcd9 <- read.csv("~/mimic2/data_ICD9-merge_final.txt")
head(dataIcd9)
## 10 most common ICD9 codes
topTenIcd9 <- names(sort(table(dataIcd9$CODE), decreasing = TRUE)[1:10])

dfTopTenIcd9 <- data.frame(icd9 = topTenIcd9)

dfTopTenIcd9 <- merge(x = dfTopTenIcd9,
                  y = dataIcd9,
                  by.x = "icd9", by.y = "CODE",
                  all.x = TRUE, all.y = FALSE # outer join
                  )
unique(dfTopTenIcd9[c("icd9","DESCRIPTION")])



## Load Note file (2GB)
## dataEventNote <- read.csv("~/mimic2/data_NOTEEVENTS-merge_final.txt")
## dim(dataEventNote)
## head(dataEventNote)
## cat(dataEventNote[2,"TEXT"])

## Load census file
dataCensusEvents <- read.csv("~/mimic2/data_CENSUSEVENTS-merge_final.txt")
dim(dataCensusEvents)
head(dataCensusEvents)
data.frame(status = table(dataCensusEvents$DISCHSTATUS))

## Load ICU stay detail (most important)
dataIcuStayDetail <- read.csv("~/mimic2/data_ICUSTAY_DETAIL-merge_final.txt")
table(dataIcuStayDetail$ICUSTAY_FIRST_CAREUNIT)

## subset to MICU patients
dataIcuStayDetail <- subset(dataIcuStayDetail,
                            ICUSTAY_FIRST_CAREUNIT == "MICU"
                            )

head(dataIcuStayDetail)
## Plot age distribution
plot(sort(dataIcuStayDetail$ICUSTAY_ADMIT_AGE))
## Plot the initial SAPSI_FIRST
plot(sort(dataIcuStayDetail$SAPSI_FIRST))
## Check NA and quantiles
sapsiFirstQuantiles <- summary(dataIcuStayDetail$SAPSI_FIRST)
sapsiFirstQuantiles <- quantile(dataIcuStayDetail$SAPSI_FIRST,
                                probs = seq(0,1,0.1), na.rm = TRUE)
sapsiFirstQuantiles
nCat <- length(sapsiFirstQuantiles) - 1

## Categorize SAPSI_FIRST into quantiles
dataIcuStayDetail$SAPSI_FIRSTCat <-
    cut(dataIcuStayDetail$SAPSI_FIRST,
        breaks = c(-Inf, tail(head(sapsiFirstQuantiles, -1), -1), Inf),
        labels = paste0("cat",seq_len(nCat)))
summary(dataIcuStayDetail$SAPSI_FIRSTCat)
## Cross table based on quartiles and in-hospital mortality
xtabs(~ SAPSI_FIRSTCat + HOSPITAL_EXPIRE_FLG, data = dataIcuStayDetail)

## Extract high SAPS survivors
highSapsiSurvivors <- subset(dataIcuStayDetail,
                             SAPSI_FIRSTCat == "cat10" &
                             HOSPITAL_EXPIRE_FLG == "N")
dim(highSapsiSurvivors)
highSapsiSurvivors$SUBJECT_ID

## Extract ICD9 for these survivors
icd9HighSapsSurvivors <- subset(dataIcd9, SUBJECT_ID %in% highSapsiSurvivors$SUBJECT_ID)
icd9HighSapsSurvivors$CODE
length(unique(icd9HighSapsSurvivors$CODE))
icd9TopTenInHighSapsSurvivor <- sort(table(icd9HighSapsSurvivors$CODE), decreasing = TRUE)[1:10]

outMerge <- merge(x = data.frame(icd9 = names(icd9TopTenInHighSapsSurvivor)),
                  y = dataIcd9,
                  by.x = "icd9", by.y = "CODE",
                  all.x = TRUE, all.y = FALSE # outer join                  
                  )
outMerge[!duplicated(outMerge$icd9),c("icd9","DESCRIPTION")]




## Load admissions
dataAdmissions <- read.csv(paste0(mimicDataDir, "data_ADMISSIONS-merge_final.txt"))
idsTopTenAdmissions <- names(sort(table(dataAdmissions$SUBJECT_ID), decreasing = TRUE)[1:10])

## ICD9 for top 10 admission patients
descIdsTopTenAdmissions <- dataIcd9[dataIcd9$SUBJECT_ID %in% idsTopTenAdmissions, "DESCRIPTION"]
sort(unique(descIdsTopTenAdmissions))




################################################################################
### Old script
## POE_ORDER-merge_final.txt (565MB)
poeOrder <- read.csv(paste0(mimicDataDir,"POE_ORDER-merge_final.txt"))

dim(poeOrder)
head(poeOrder)


## PROCEDUREEVENTS-merge_final.txt (4.8MB)
procedureEvents <- read.csv(paste0(mimicDataDir, "PROCEDUREEVENTS-merge_final.txt"))

dim(procedureEvents)


