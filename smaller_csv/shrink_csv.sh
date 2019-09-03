#!/bin/bash

lines_to_delete=19138

for arg
do
	# Delete first line, since it's just a header
	sed -i "1d" $arg

	# Delete 19138 lines, since the time is measured
	# in nanoseconds, and increment line pointer.
	# The file will end up with 120
	# lines ranging from 5 to 600 seconds.
	for i in {1..120}
	do
		sed -i "$i,$lines_to_delete d" $arg
	done

	# The csv files generated by CCS may differ in length.
	# This command ensures that all remaining lines not 
	# affected by the previous command are deleted.
	sed -i "121,\$d" $arg
done
