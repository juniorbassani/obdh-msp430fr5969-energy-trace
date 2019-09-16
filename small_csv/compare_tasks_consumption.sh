#!/bin/bash

# Receives two arguments (csv files). Read the same line of each file,
# calculate the difference between the energy variation of each file
# and store the results in a new file

if [ $# != 2 ]; then
    echo 'Exactly 2 CSV files need to be send to this script'
    exit 1
fi

lines1=$(wc -l $1 | awk '{print $1}')
lines2=$(wc -l $2 | awk '{print $1}')
lines=0

if [ $lines1 -le $lines2 ]; then
    lines=$lines1
else
    lines=$lines2
fi

file1=$1
file2=$2

echo 'Time (ns),Variation (uJ)' > output.csv

# Loop begins in 2 to exclude header from being processed
for (( i = 2; i <= $lines; i++ )); do
    # Whole line
    file1_data=$(sed "$i q;d" $file1)
    file2_data=$(sed "$i q;d" $file2)

    time1=$(sed 's/"//g' <<< $(echo $file1_data | awk -F, '{print $1}'))
    time2=$(sed 's/"//g' <<< $(echo $file2_data | awk -F, '{print $1}'))
    time_average=$(echo "scale=2; ($time1 + $time2) / 2" | bc -l)

    # Only variation field
    file1_data=$(echo $file1_data | awk -F, '{print $5}')
    file1_data=$(sed 's/"//g' <<< $file1_data)

    file2_data=$(echo $file2_data | awk -F, '{print $5}')
    file2_data=$(sed 's/"//g' <<< $file2_data)

    res=$(echo "$file1_data - $file2_data" | bc -l)
    
    # Surround the data with double quotes
    time_average=$(sed "s/.*/\"&\",/" <<< $time_average)
    res=$(sed "s/.*/\"&\"/" <<< $res)

    # Store the results in a CSV file
    echo "${time_average}${res}" >> output.csv
done
