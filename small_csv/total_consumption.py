import sys
import os
import re
from itertools import groupby 

DIR = 'total_consumption'

def group(str):
    str = os.path.splitext(os.path.basename(str))[0]
    str = re.sub('[0-9]', '', str)

    return str

def filter(str):
    files = []

    for i in range(0, len(str)):
        if len(str[i]) > 2:
            files.append(str[i])

    return files

if len(sys.argv) < 2:
    print('Arguments required')
    sys.exit(-1)

args = sys.argv[1:]

args.sort() 
res = [list(i) for j, i in groupby(args, group)] 
res = filter(res)

if not os.path.exists(DIR):
    os.mkdir(DIR)

for files in res:
    name = os.path.splitext(os.path.basename(files[0]))[0]
    name = re.sub('[0-9]', '', name)

    cons = open(DIR + '/' + name + '.txt', 'w')
    cur_cons = []

    for file in files:
        f = open(file, 'r')
        row = f.readlines()[-1]

        energy = float(row.split(',')[-2].split('"')[1])
        cur_cons.append(energy)

    avg = sum(cur_cons) / len(cur_cons)
    cons.write(str(avg) + '\n')
    cons.close()
