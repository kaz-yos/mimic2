#!/usr/local/bin/python3

### Individual data file concatenater
## This Python3 script concatenates all the individual files of the same data type.
## It also removes

## Import libraries
import os

## Specifiy folder to work on
os.chdir('/Users/kazuki/mimic2')

## Define the folder number range
folders = range(0,33)

## Ask for the file name
## eg. A_CHARTDURATIONS-26000.txt
data_file_name = input("Give the data file name to be concatenated (exclude the ID and extension, eg. A_CHARTDURATIONS- ): ")

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
merge_file_final = open(file = data_file_name + "merge_final.txt", mode = "w")

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
