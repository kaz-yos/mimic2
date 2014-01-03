#!/usr/local/bin/python3

### Individual data file concatenater
## This Python3 script concatenates all the individual files of the same data type.
## It also removes duplicated headers.

## Import libraries
import os

## Specifiy folder to work on. This folder needs to have folders 00-32. The merged data is created here
os.chdir('/Users/kazuki/mimic2')

## Ask for the folder range
end_plus_one = input("Give the end of range (starts at 00; max 32; default 32): ")    # text
## If empty give 33 (full range)
if end_plus_one == "":
    end_plus_one = 33
## Otherwise add one
else:
    end_plus_one = int(end_plus_one)
    end_plus_one = end_plus_one + 1
## Define the folder number range
folders = range(0, end_plus_one)

## Create a named dictionary of variables
dict_of_tables = {1:'ADDITIVES-',
2:'ADMISSIONS-',
3:'A_CHARTDURATIONS-',
4:'A_IODURATIONS-',
5:'A_MEDDURATIONS-',
6:'CENSUSEVENTS-',
7:'CHARTEVENTS-',
8:'COMORBIDITY_SCORES-',
9:'DELIVERIES-',
10:'DEMOGRAPHICEVENTS-',
11:'DEMOGRAPHIC_DETAIL-',
12:'DRGEVENTS-',
13:'D_PATIENTS-',
14:'ICD9-',
15:'ICUSTAYEVENTS-',
16:'ICUSTAY_DAYS-',
17:'ICUSTAY_DETAIL-',
18:'IOEVENTS-',
19:'LABEVENTS-',
20:'MEDEVENTS-',
21:'MICROBIOLOGYEVENTS-',
22:'NOTEEVENTS-',
23:'POE_MED-',
24:'POE_ORDER-',
25:'PROCEDUREEVENTS-',
26:'TOTALBALEVENTS-'}
## Show
print("You will choose from:\n")
print(dict_of_tables, "\n")

# ## Ask for the file name
# ## eg. A_CHARTDURATIONS-26000.txt
# ## data_file_name = input("Give the data file name to be concatenated (exclude the ID and extension, eg. A_CHARTDURATIONS- ): ")
# data_file_number = int(input("Give the data file number: "))
# data_file_name = dict_of_tables[data_file_number]


## The remaining part is looped over the dict elements
for i in range(len(dict_of_tables)):
    data_file_name = dict_of_tables[(i + 1)]    # Need to adjust the number

    ## Open connection to a merge file (The first argument is "file" in version three.)
    merge_file = open(file = data_file_name + "merge.txt", mode = "w")

    ## 1st level "for" is for folders 00-32
    for folder in folders:  # Loop for each folder
        ## Padding by a preceeding zero
        folder = "0" + str(folder)
        ## Keep last two letters only
        folder = folder[-2] + folder[-1]
        ## Show message
        print("Moving into ", folder)
        ## Move into the folder
        os.chdir(folder)

        ## 2nd level "for" is for loop for each patient: 000-999 within the folder
        subfolders = os.listdir()
        for subfolder in subfolders:        # for loop for each patient folder
            filename = subfolder + "/" + data_file_name + subfolder + ".txt"
            if not os.path.isfile(filename):    # If not such file exists, go to the next iteraction
                print("No such file:", filename)
                pass
            else:   # If the file exists,
                print("Working on ", filename)
                ## Open the file to work on read-only
                file_current = open(file = filename, mode = "r")
                ## While loop for line by line addition to the merge file
                while True:
                    line_current = file_current.readline()
                    if line_current == "":  # End at EOF
                        break
                    else:
                        merge_file.write(line_current)
                ## Close the file
                file_current.close()

        ## Get back to the parent directory to work on the next folder
        os.chdir("..")

    ## Close the resulting file
    merge_file.close()



    ### Remove duplicated headers

    ## Open for reading
    merge_file = open(file = data_file_name + "merge.txt", mode = "r")

    ## Get the first line of the written file (header line)
    first_line = merge_file.readline()

    ## Open the final version for writing
    merge_file_final = open(file = "data_" + data_file_name + "merge_final.txt", mode = "w")

    ## Write the header
    merge_file_final.write(first_line)

    ## Show a message
    print("Now deleting duplicated headers")

    ## Initialized a counter
    count = 0

    ## Remove
    while True:
        line_current = merge_file.readline()
        if line_current == "":
            break
        else:
            ## If it matches with the header, do not write (pass)
            if line_current == first_line:
                # print("Duplicated header deleted!")
                pass
                count = count + 1
            ## If it does not match, write to the second file
            else:
                merge_file_final.write(line_current)

    ## Print message
    print(count, "duplicated headers removed!")

    ## Close files
    merge_file.close()
    os.remove(data_file_name + "merge.txt")
    merge_file_final.close()
