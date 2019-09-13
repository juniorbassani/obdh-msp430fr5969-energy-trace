#!/bin/bash

total_data=600

for arg
do
    lines_to_delete=$(wc -l $arg | awk '{print $1}')
    lines_to_delete=$((($lines_to_delete - 1) / $total_data))

    line_counter=1
    prev=0
  
    # Include another field in header
    header=$(sed "1 q;d" $arg)
    sed '1s/$/;Variation (uJ)/' <<< $header > .tmp.csv
  
    # Select lines that range from n to n seconds
    # in the csv file, calculate the variation since the
    # previous energy measurement and write the complete
    # result in the temporary file
    for (( i = 1; i <= $total_data; i++))
    do
        line_counter=$(($line_counter + $lines_to_delete))
        line=$(sed "$line_counter q;d" $arg)
  
        # Ensure string isn't null before doing anything
        if ! [ -z $line ]
        then
            curr=$(echo $line | awk -F\; '{print $4}')
            curr=$(sed 's/"//g' <<< $curr)
  
            res=$(echo "$curr - $prev" | bc -l)
            prev=$curr
  
            line=$(sed "s/$/,\"$res\"/" <<< $line)
  
            echo $line >> .tmp.csv
            lines=$(($lines - $i))
        fi
    done
  
    # Replace semicolons by commas
    sed -i 's/;/,/g' .tmp.csv
  
    # Rename temporary file with the name of the argument
    mv .tmp.csv $arg
done
