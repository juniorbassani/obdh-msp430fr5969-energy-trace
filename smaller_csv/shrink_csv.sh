#!/bin/bash

lines_to_delete=19138
count=1

for arg
do
	# Delete first line, since it's a header
	sed -i "1d" $arg

	for i in {1..120}
	do
		sed -i "$i,$lines_to_delete d" $arg
	done
done
