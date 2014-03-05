## MySQL Test script

## Show server status
status;

## Show which user I am
SELECT USER();
## +------------------+
## | USER()           |
## +------------------+
## | mimic2@localhost |
## +------------------+
## 1 row in set (0.00 sec)


## Show the list
SHOW DATABASES;

## Pick mimic2 DB
USE mimic2;

## List tables 
SHOW TABLES;

## Describe a table
DESCRIBE icustay_detail;

## One condition
SELECT * FROM icustay_detail
	WHERE subject_id = 1;

## Two conditions
SELECT subject_id,icustay_id
	FROM icustay_detail
	WHERE subject_id = 1 AND icustay_id = 2;

## Check number of observations
SELECT COUNT(*) from icustay_detail;

## For a very large dataset
SELECT COUNT(*) from chartevents;


### Multiple condtions to a temporary table of the study cohort
## CREATE TEMPORARY TABLE IF NOT EXISTS table2 AS (SELECT * FROM table1) # () not required
## http://stackoverflow.com/questions/5859391/create-a-temporary-table-in-a-select-statement-without-a-separate-create-table

## CREATE A TEMPORARY TABLE (temporary tables are not accessible create real ones!)
## CREATE TEMPORARY TABLE IF NOT EXISTS _temp_subject_id AS	# AS is not needed
CREATE TABLE IF NOT EXISTS _temp_subject_id
	SELECT *
	FROM icustay_detail
	WHERE HOSPITAL_FIRST_FLG = "Y"
	AND ICUSTAY_FIRST_FLG = "Y"
	AND ICUSTAY_FIRST_CAREUNIT = "MICU"
	AND SAPSI_FIRST > 20;

## DESCRIBE
describe _temp_subject_id;
## describe mimic2._temp_subject_id;	# Same

## Count
select count(*) from _temp_subject_id;

## Show first 10
select ICUSTAY_FIRST_CAREUNIT,SUBJECT_ID,GENDER,DOB,SAPSI_FIRST,HOSPITAL_EXPIRE_FLG from _temp_subject_id LIMIT 10;

## Count death
select HOSPITAL_EXPIRE_FLG,count(*) FROM _temp_subject_id
	GROUP BY HOSPITAL_EXPIRE_FLG;

## Now it is a real table, thus, visible.
SHOW DATABASES;
SHOW TABLES;


### Extract rows using the ID held in _temp_subject_id

## Describe the table to pull data from
describe mimic2.chartevents;

## Create a new temp DB (INNER JOIN)
CREATE TABLE _temp_itemid211
	-- SELECT _temp_subject_id.SUBJECT_ID AS tempId, chartevents.* 
	SELECT chartevents.* 	        # Only from the table on the right
	FROM _temp_subject_id		# left table
	INNER JOIN chartevents		# right table
	ON _temp_subject_id.SUBJECT_ID = chartevents.SUBJECT_ID
	WHERE ITEMID = 211;
-- Query OK, 126014 rows affected (19.52 sec)
-- Records: 126014  Duplicates: 0  Warnings: 0
describe mimic2._temp_itemid211;

## Check
describe mimic2._temp_itemid211;

## Check row number
SELECT count(*) FROM _temp_itemid211;

## Show first 10
SELECT * FROM _temp_itemid211
	LIMIT 10;

## Check distinct IDs
SELECT DISTINCT SUBJECT_ID FROM _temp_itemid211;
## SELECT DISTINCT SUBJECT_ID FROM CHARTEVENTS;

## Write to a file
-- SELECT * FROM _temp_itemid211
-- 	FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
-- 	INTO OUTFILE '/var/tmp/out.csv';

## Required FILE privilege on both 'mimic2'@'%' and 'mimic2'@'localhost'
SELECT * FROM _temp_itemid211
	INTO OUTFILE '/Users/kazuki/mimic2/mysql_hr.csv'
	;

## Comorbidity score
CREATE TABLE _temp_comorbid
	SELECT comorbidity_scores.*	# all from the right table
	FROM _temp_subject_id
	LEFT JOIN comorbidity_scores
	ON _temp_subject_id.SUBJECT_ID = comorbidity_scores.SUBJECT_ID
	AND _temp_subject_id.hadm_id = comorbidity_scores.hadm_id
	;
-- Query OK, 497 rows affected (1.54 sec)
-- Records: 497  Duplicates: 0  Warnings: 0

## Describe it
describe _temp_comorbid;

## Export to a file (Not very useful. hard to get the column names.)
-- SELECT * FROM _temp_comorbid
-- 	INTO OUTFILE '/Users/kazuki/mimic2/mysql_comorbid.csv'	
-- 	;
## Query OK, 497 rows affected (0.00 sec)


## Check availability
SHOW DATABASES;
SHOW TABLES;



### Simple statistics

## Query grouped by sex
SELECT sex, COUNT(*)
	FROM d_patients
	GROUP BY sex;
-- +------+----------+
-- | sex  | COUNT(*) |
-- +------+----------+
-- |      |       48 |
-- | F    |    14288 |
-- | M    |    18199 |
-- +------+----------+
-- 3 rows in set (0.56 sec)
