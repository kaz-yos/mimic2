### Test script

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
head(sort(table(dataIcd9$CODE), decreasing = TRUE), 10)


## Load Note file
dataEventNote <- read.csv("~/mimic2/data_NOTEEVENTS-merge_final.txt")
dim(dataEventNote)

head(dataEventNote)
dataEventNote[1,"TEXT"]


### Old script
## POE_ORDER-merge_final.txt (565MB)
poeOrder <- read.csv(paste0(mimicDataDir,"POE_ORDER-merge_final.txt"))

dim(poeOrder)
head(poeOrder)


## PROCEDUREEVENTS-merge_final.txt (4.8MB)
procedureEvents <- read.csv(paste0(mimicDataDir, "PROCEDUREEVENTS-merge_final.txt"))

dim(procedureEvents)


