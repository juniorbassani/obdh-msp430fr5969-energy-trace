import sys
import os
import re

HEADER = 'Time (ns),Variation (uJ)'

if len(sys.argv) < 2:
    print('Arguments required')
    sys.exit(-1)

name = os.path.splitext(os.path.basename(sys.argv[1]))[0]
name = re.sub('[0-9]', '', name)
name = 'avg/' + name + '_avg.csv'

average_file = open(name, 'w')

average_file.write(HEADER + '\n')
average_file.flush()

time = []
variation = []

for f in sys.argv[1:]:
    cur_time = []
    cur_variation = []

    with open(f, mode='r') as f:
        lines = f.readlines()[1:]

        for row in lines:
            values = row.split(',')
            cur_variation.append(float(values[-1].split('"')[1]))
            cur_time.append(float(values[0].split('"')[1]))

        time.append(cur_time)
        variation.append(cur_variation)

        f.close()

for j in range(0, len(variation[0])):
    time_avg = 0
    var_avg = 0

    for i in range(0, len(variation)):
        time_avg += time[i][j]
        var_avg += variation[i][j]

    time_avg /= len(variation)
    var_avg /= len(variation)
    str_fmt = '"{}","{}"'.format(time_avg, var_avg)

    average_file.write(str_fmt + '\n')
    average_file.flush()

average_file.close()
