#!/bin/bash

lines_to_delete=19138

for arg
do
    line_counter=1
    previous=0

    # Include another field in header
    header=$(sed "1 q;d" $arg)
    sed '1s/$/;Variation (uJ)/' <<< $header > .tmp.csv

    # Select lines that range from five to five seconds
    # in the csv file, calculate the variation since the
    # previous energy measurement and write the complete
    # result into the temporary file
    for i in {1..120}
    do
        line_counter=$(($line_counter + $lines_to_delete))
        line=$(sed "$line_counter q;d" $arg)

        # Ensure string isn't null before doing anything
        if ! [ -z $line ]
        then
            curr=$(echo $line | awk -F\; '{print $4}')
            curr=$(sed 's/"//g' <<< $curr)

            res=$(echo "$curr - $previous" | bc -l)
            previous=$curr

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
