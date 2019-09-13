#!/bin/bash

# Read two arguments (csv files). Read same line of each file
# and calculate the difference between the energy variation of each file
# Store the results in a new file

# if [ $# != 3 ]
    # exit -1
# 
lines=$(wc -l $1 | awk '{print $1}')
# 
# if [ $lines != $(wc -l $2 | awk '{print $1}') ]
    # exit -1

file1=$1
file2=$2

echo 'Time (ns),Variation (uJ)' > output

# Loop begins in 2 to exclude header from being processed
for (( i = 2; i <= $lines; i++ )); do
    # Whole line
    file1_data=$(sed "$i q;d" $file1)
    file2_data=$(sed "$i q;d" $file2)

    time1=$(sed 's/"//g' <<< $(echo $file1_data | awk -F, '{print $1}'))
    time2=$(sed 's/"//g' <<< $(echo $file2_data | awk -F, '{print $1}'))
    time_average=$(echo "($time1 + $time2) / 2" | bc -l)

    # Only variation field
    file1_data=$(echo $file1_data | awk -F, '{print $5}')
    file1_data=$(sed 's/"//g' <<< $file1_data)

    file2_data=$(echo $file2_data | awk -F, '{print $5}')
    file2_data=$(sed 's/"//g' <<< $file2_data)

    res=$(echo "$file1_data - $file2_data" | bc -l)
    
    time_average=$(sed "s/.*/\"&\",/" <<< $time_average)
    res=$(sed "s/.*/\"&\"/" <<< $res)

    echo "${time_average}${res}" >> output
done
