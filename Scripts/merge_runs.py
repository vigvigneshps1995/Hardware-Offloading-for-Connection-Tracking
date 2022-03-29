#!/usr/bin/python3

# Merges runs based on index computed by line number.
# Input should be a file output from generator.click.
# Output file will be saved at same place as input file.


import sys
import csv

if len(sys.argv) < 2:                   # "tired human" check.
  print("Usage: ./merge_run.py file")
  quit()

def add(old,new,f):
  if(old == None or new == ''):
    return old
  if(f): return old + float(new)
  else: return old + int(new)

title_row = []                          
data = {}                               # key (Time): [len, TxCount, RxCount, TxRate, Rxrate, PacketLoss, LAT, LAT95, LAT99]
new_file_name = sys.argv[1].replace('.csv', '-avg.csv')
index = 0.0

with open(sys.argv[1]) as csv_file:
  csv_reader = csv.reader(csv_file)
  title_row = csv_reader.__next__()
  for row in csv_reader:               # Add all rows to it's data entry and increace len by one each time
    row0 = round(float(row[0]),1)
    if row0 < index: index = 0.1
    else: index = round((index + 0.1),1)
    if index in data:
      d = data[index]
      data[index] = [d[0]+1, add(d[1],row[1],0), add(d[2],row[2],0), d[3]+float(row[3]), d[4]+float(row[4]), add(d[5],row[5],1), add(d[6],row[6],1), d[7]+int(row[7]), d[8]+int(row[8])]
    else:
      if int(index*10)-int(index)*10 == 1:
        data[index] = [1, int(row[1]), int(row[2]), float(row[3]), float(row[4]), float(row[5]), float(row[6]), int(row[7]), int(row[8])]
      else:
        data[index] = [1, None, None, float(row[3]), float(row[4]), None, None, int(row[7]), int(row[8])]
  csv_file.close

with open(new_file_name, "w") as new_file:
  csv_writer = csv.writer(new_file)
  csv_writer.writerow(title_row)
  item_list = sorted(data.items())
  for key, item in item_list:      # Average values based on 'len' and write to new file
      if item[1]:
        row = [key, str(int(item[1]/item[0])), str(int(item[2]/item[0])), str(item[3]/item[0] / 1e9), str(item[4]/item[0] / 1e9), str(item[5]/item[0]) if item[5] > 0 else 0, str(item[6]/item[0]), str(int(item[7]/item[0])), str(int(item[8]/item[0]))]
      else: 
        row = [key, None, None, str(item[3]/item[0] / 1e9), str(item[4]/item[0] / 1e9), None, None, str(int(item[7]/item[0])), str(int(item[8]/item[0]))]
      csv_writer.writerow(row)
