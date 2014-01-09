### Script to load csv files and put it into a MySQL database.

## 26 flat files. 
## -rw-r--r--     1 kazuki  staff    12M Jan  6 20:17 data_ADDITIVES-merge_final.txt
## -rw-r--r--     1 kazuki  staff   1.1M Jan  6 20:18 data_ADMISSIONS-merge_final.txt
## -rw-r--r--     1 kazuki  staff   279M Jan  6 20:19 data_A_CHARTDURATIONS-merge_final.txt
## -rw-r--r--     1 kazuki  staff    31M Jan  6 20:20 data_A_IODURATIONS-merge_final.txt
## -rw-r--r--     1 kazuki  staff    13M Jan  6 20:21 data_A_MEDDURATIONS-merge_final.txt
## -rw-r--r--     1 kazuki  staff   4.3M Jan  6 20:22 data_CENSUSEVENTS-merge_final.txt
#### -rw-r--r--     1 kazuki  staff    19G Jan  6 20:40 data_CHARTEVENTS-merge_final.txt
## -rw-r--r--     1 kazuki  staff   2.9M Jan  6 20:42 data_COMORBIDITY_SCORES-merge_final.txt
## -rw-r--r--     1 kazuki  staff   5.3M Jan  6 20:44 data_DELIVERIES-merge_final.txt
## -rw-r--r--     1 kazuki  staff   3.6M Jan  6 20:46 data_DEMOGRAPHICEVENTS-merge_final.txt
## -rw-r--r--     1 kazuki  staff   4.6M Jan  6 20:47 data_DEMOGRAPHIC_DETAIL-merge_final.txt
## -rw-r--r--     1 kazuki  staff   777K Jan  6 20:49 data_DRGEVENTS-merge_final.txt
## -rw-r--r--     1 kazuki  staff   897K Jan  6 20:51 data_D_PATIENTS-merge_final.txt
## -rw-r--r--     1 kazuki  staff    19M Jan  6 20:53 data_ICD9-merge_final.txt
## -rw-r--r--     1 kazuki  staff   2.7M Jan  6 20:55 data_ICUSTAYEVENTS-merge_final.txt
## -rw-r--r--     1 kazuki  staff    16M Jan  6 20:57 data_ICUSTAY_DAYS-merge_final.txt
## -rw-r--r--     1 kazuki  staff   8.6M Jan  6 20:58 data_ICUSTAY_DETAIL-merge_final.txt
#### -rw-r--r--     1 kazuki  staff   1.0G Jan  6 21:01 data_IOEVENTS-merge_final.txt
#### -rw-r--r--     1 kazuki  staff   1.1G Jan  6 21:04 data_LABEVENTS-merge_final.txt
## -rw-r--r--     1 kazuki  staff   450M Jan  6 21:06 data_MEDEVENTS-merge_final.txt
## -rw-r--r--     1 kazuki  staff    23M Jan  6 21:07 data_MICROBIOLOGYEVENTS-merge_final.txt
#### -rw-r--r--     1 kazuki  staff   1.8G Jan  6 21:12 data_NOTEEVENTS-merge_final.txt
## -rw-r--r--     1 kazuki  staff   170M Jan  6 21:14 data_POE_MED-merge_final.txt
## -rw-r--r--     1 kazuki  staff   539M Jan  6 21:16 data_POE_ORDER-merge_final.txt
## -rw-r--r--     1 kazuki  staff   4.5M Jan  6 21:18 data_PROCEDUREEVENTS-merge_final.txt
## -rw-r--r--     1 kazuki  staff   199M Jan  6 21:20 data_TOTALBALEVENTS-merge_final.txt


## A_CHARTDURATIONS
A_CHARTDURATIONS <- read.csv("~/mimic2/data_A_CHARTDURATIONS-merge_final.txt")
str(A_CHARTDURATIONS)
## 'data.frame':	3196523 obs. of  9 variables:
##  $ SUBJECT_ID   : int  4 4 4 4 4 4 4 4 4 4 ...
##  $ ICUSTAY_ID   : int  5 5 5 5 5 5 5 5 5 5 ...
##  $ ITEMID       : int  660 82 1703 1623 1622 1517 1337 1125 763 742 ...
##  $ ELEMID       : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ STARTTIME    : Factor w/ 344789 levels "2500-11-06 14:00:00 EST",..: 306537 306538 306538 306538 306538 306538 306538 306538 306538 306538 ...
##  $ STARTREALTIME: Factor w/ 404550 levels "2500-11-06 14:31:00 EST",..: 359447 359445 359445 359445 359445 359445 359445 359445 359445 359445 ...
##  $ ENDTIME      : Factor w/ 32575 levels "","2500-11-06 18:38:00 EST",..: 29081 29081 29081 29081 29081 29081 29081 29081 29081 29081 ...
##  $ CUID         : int  69 69 69 69 69 69 69 69 69 69 ...
##  $ DURATION     : int  2386 2356 2356 2356 2356 2356 2356 2356 2356 2356 ...


### test MySQL connection
## Load the package
library(RMySQL)
## Establish a connection
## PASSWORD <- ""  # Use appropriate one
mimic2 <- dbConnect(MySQL(), user = "root", password = PASSWORD, dbname = "mimic2", host = "localhost")
## Check connection
summary(mimic2)
## List tables
dbListTables(conn = mimic2)
## List fields in a table
dbListFields(conn = mimic2, name = "comorbidity_scores")
## Create a table from a file
## additives <- read.csv("~/mimic2/data_ADDITIVES-merge_final.txt")
## dbWriteTable(conn = mimic2, name = "additives", value = additives) ## table from a file


## Define a function to simplify this
LoadFileAndWriteToMySQL <- function(conn, name = "") {

    ## Print
    cat(paste("Working on: "), name, "\n")

    ## Get the file name
    filename <- paste0("~/mimic2/data_", toupper(name) ,"-merge_final.txt")

    ## Load
    dataFrame <- read.csv(file = filename)

    ## Write to the database
    dbWriteTable(conn = conn, name = name, value = dataFrame,
                 row.names = FALSE, overwrite = FALSE, append = FALSE)
}


## List names of the databases that are small enough (< 1 GB).
databaseNames <- c("additives","admissions","a_chartdurations","a_iodurations","a_meddurations","censusevents","comorbidity_scores","deliveries","demographicevents","demographic_detail","drgevents","d_patients","icd9","icustayevents","icustay_days","icustay_detail","medevents","microbiologyevents","poe_med","poe_order","procedureevents","totalbalevents")

## Loop over
for (databaseName in databaseNames) {

    ## Run the function
    LoadFileAndWriteToMySQL(conn = mimic2, name = databaseName)
}

## Larger files require other approach
#### -rw-r--r--     1 kazuki  staff    19G Jan  6 20:40 data_CHARTEVENTS-merge_final.txt # Absolute indication
#### -rw-r--r--     1 kazuki  staff   1.0G Jan  6 21:01 data_IOEVENTS-merge_final.txt
#### -rw-r--r--     1 kazuki  staff   1.1G Jan  6 21:04 data_LABEVENTS-merge_final.txt
#### -rw-r--r--     1 kazuki  staff   1.8G Jan  6 21:12 data_NOTEEVENTS-merge_final.txt



## close connection
dbDisconnect(mimic2)
