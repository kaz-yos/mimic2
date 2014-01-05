### Load dataset and merge

## Load a library
library(doBy)

## Load them together as a list
listOfDatasets <- list(read.csv("~/mimic2/data_CHARTEVENTS-HR-unique.txt"),
                       read.csv("~/mimic2/data_CHARTEVENTS-vent-use.txt"),
                       read.csv("~/mimic2/data_CHARTEVENTS-sat-first.txt")
                       )

## Merge as a data frame
outputDataset <- Reduce(f = merge, x = listOfDatasets)


## Order by subject ID
outputDataset <- orderBy(~  +SUBJECT_ID, outputDataset)

## Write out
## write.csv(outputDataset, file = "~/mimic2/data__merge.csv", row.names = F, na = "")



### Load data files from Chris
## Primary dataset first rows only
dataPrimary <- read.csv("~/mimic2/chrisData/primary.csv")
dataPrimary <- dataPrimary[!duplicated(dataPrimary$SUBJECT_ID),]
dataPrimary <- dataPrimary[c("SUBJECT_ID","SAPSI_FIRST","ICUSTAY_EXPIRE_FLG")]

dataPrimary$ICUSTAY_EXPIRE_FLG <- as.character(factor(dataPrimary$ICUSTAY_EXPIRE_FLG, levels = c("N","Y"), labels = c(1,0)))
table(dataPrimary$ICUSTAY_EXPIRE_FLG)


## temperature non-overlapping, combine
dataCels <- read.csv("~/mimic2/chrisData/celsius.csv")
dataFaren <- read.csv("~/mimic2/chrisData/fahrenheittocelsius.csv")

## Merge
dataTemp <- merge(x = dataCels,
                  y = dataFaren,
                  by = "SUBJECT_ID",
                  all.x = TRUE, all.y = FALSE # outer join
                  )

## if missing replace with .y
dataTemp$TEMPERATURE.x[is.na(dataTemp$TEMPERATURE.x)] <-
    dataTemp$TEMPERATURE.y[is.na(dataTemp$TEMPERATURE.x)]
dataTemp$TEMPERATURE <- dataTemp$TEMPERATURE.x
dataTemp$TEMPERATURE.x <- NULL
dataTemp$TEMPERATURE.y <- NULL

## comorbidities
dataComorbid <- read.csv("~/mimic2/chrisData/elixhauser.csv")

## WBC
dataWbc <- read.csv("~/mimic2/chrisData/wbc.csv")

## Combine as a list
listOfDatasetsChris <- list(dataPrimary, dataTemp, dataComorbid, dataWbc)

## Merge as a data frame
outputDatasetChris <- Reduce(f = merge, x = listOfDatasetsChris)

## Combine
finalData <- merge(x = outputDataset,
                  y = outputDatasetChris,
                  by = c("SUBJECT_ID"),
                  all.x = FALSE, all.y = TRUE # right join
                  )

dput(names(finalData))


colOrder <- c("SUBJECT_ID", "ICUSTAY_ID", "HR", "vent", "sat", "SAPSI_FIRST",  "TEMPERATURE", "CONGESTIVE_HEART_FAILURE", "CARDIAC_ARRHYTHMIAS", "VALVULAR_DISEASE", "PULMONARY_CIRCULATION", 
"PERIPHERAL_VASCULAR", "HYPERTENSION", "PARALYSIS", "OTHER_NEUROLOGICAL", "DIABETES_COMPLICATED", "DIABETES_UNCOMPLICATED", "HYPOTHYROIDISM", "RENAL_FAILURE", "LIVER_DISEASE", "PEPTIC_ULCER", "AIDS", "LYMPHOMA", "METASTATIC_CANCER", "SOLID_TUMOR", "RHEUMATOID_ARTHRITIS", "COAGULOPATHY", "OBESITY", "WEIGHT_LOSS", "FLUID_ELECTROLYTE", "BLOOD_LOSS_ANEMIA", 
"DEFICIENCY_ANEMIAS", "ALCOHOL_ABUSE", "DRUG_ABUSE", "PSYCHOSES", "DEPRESSION", "WBC", "ICUSTAY_EXPIRE_FLG")


## Final dataset!!!!
finalData <- finalData[colOrder]

## write out!!!!!
write.csv(finalData, "~/mimic2/data__final.csv", row.names = F, na = "")
