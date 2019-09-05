#!/bin/bash

# This script calculates the variation in uJ from 
# the provided csv file line by line and includes
# the result in another field in the same file
# Doesn't look too good, but works

counter=1

for arg; do
    # Include another field in header
    sed '1s/$/;Variation (uJ)/' $arg > .res.csv

    # Delete contents of the files used to store data
    > .energy.csv
    > .final_result.csv
    > .ultimate_result.csv

    # Read the csv file line by line and store 
    # the energy of the line in the file .energy.csv
    while IFS= read -r line; do
        if [ $counter -gt 1 ]; then
            formatted=$(echo $line | awk -F\; '{print $4}')
            formatted=$(sed 's/"//g' <<< $formatted)

            echo $formatted >> .energy.csv
        fi

        ((counter++))
    done < .res.csv

    counter=2
    previous=0

    echo $(sed "1q;d" .res.csv) > .ultimate_result.csv

    # Read the lines of .energy.csv, which only contains the energy
    # data, in uJ, calculates the variation and save in an intermediate file
    while IFS= read -r line; do
        curr=$line
        res=$(echo "$curr - $previous" | bc -l)
        previous=$curr

        sed "s/$/;\"$res\"/" <<< $(sed "$counter q;d" $arg) >> .ultimate_result.csv
        ((counter++))
    done < .energy.csv

    mv .ultimate_result.csv $arg
    rm .energy.csv .final_result.csv
done
