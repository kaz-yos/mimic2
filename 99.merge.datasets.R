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
dataPrimary <- dataPrimary[c("SUBJECT_ID","SAPSI_FIRST","ICUSTAY_EXPIRE_FLG","AGE")]

dataPrimary$ICUSTAY_EXPIRE_FLG <- as.character(factor(dataPrimary$ICUSTAY_EXPIRE_FLG, levels = c("N","Y"), labels = c(1,0)))
## convert to numerics
dataPrimary$ICUSTAY_EXPIRE_FLG <- as.numeric(dataPrimary$ICUSTAY_EXPIRE_FLG)
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


## Check NA's
summary(finalData)

## Keep original
finalDataOrig <- finalData

## Mean imputation
finalData[,c(-1,-2,-7)] <- sapply(finalDataOrig[,c(-1,-2,-7)],
                      FUN = function(VAR) {

                          ## Get the mean
                          meanVal <- mean(VAR, na.rm = T)

                          ## NA replaced with the mean
                          VAR[is.na(VAR)] <- meanVal

                          ## Return it
                          VAR
                      },
                      simplify = FALSE)


## Choose ordering
colOrder <- c("SUBJECT_ID", "AGE", "HR", "vent", "sat", "SAPSI_FIRST",  "TEMPERATURE", "CONGESTIVE_HEART_FAILURE", "CARDIAC_ARRHYTHMIAS", "VALVULAR_DISEASE", "PULMONARY_CIRCULATION", "PERIPHERAL_VASCULAR", "HYPERTENSION", "PARALYSIS", "OTHER_NEUROLOGICAL", "DIABETES_COMPLICATED", "DIABETES_UNCOMPLICATED", "HYPOTHYROIDISM", "RENAL_FAILURE", "LIVER_DISEASE", "PEPTIC_ULCER", "AIDS", "LYMPHOMA", "METASTATIC_CANCER", "SOLID_TUMOR", "RHEUMATOID_ARTHRITIS", "COAGULOPATHY", "OBESITY", "WEIGHT_LOSS", "FLUID_ELECTROLYTE", "BLOOD_LOSS_ANEMIA", "DEFICIENCY_ANEMIAS", "ALCOHOL_ABUSE", "DRUG_ABUSE", "PSYCHOSES", "DEPRESSION", "WBC", "ICUSTAY_EXPIRE_FLG")


## Final dataset!!!!
finalData <- finalData[colOrder]

## write out!!!!!
write.csv(finalData, "~/mimic2/data__final.csv", row.names = F, na = "")


## Write out as Excel
## http://d.hatena.ne.jp/dichika/20131003/p1
library(XLConnect)
wb <- loadWorkbook("data__final.XLConnect.xls", create = TRUE)
wb["1"] <- finalData
saveWorkbook(wb)



### Logistic regression (analysis is four lines of code!!!!???)
resGlm <- glm(formula = ICUSTAY_EXPIRE_FLG ~ . -SUBJECT_ID -BLOOD_LOSS_ANEMIA,
              family  = binomial(link = "logit"),
              data    = finalData)
summary(resGlm)

## library(epicalc)
## epicalc::logistic.display(resGlm)
