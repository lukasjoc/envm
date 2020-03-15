#!/usr/bin/env python3

## This was taken from StackOverflow https://apple.stackexchange.com/questions/4286/is-there-a-mac-os-x-terminal-version-of-the-free-command-in-linux-systems
## kudos to them I just converted it to python3 and changed single quotes to double quotes ;) and really its mebibyte if you use 1024 isnt't it.. 

import subprocess
import re

# Get process info
ps = subprocess.Popen(["ps", "-caxm", "-orss,comm"], stdout=subprocess.PIPE).communicate()[0].decode()
vm = subprocess.Popen(["vm_stat"], stdout=subprocess.PIPE).communicate()[0].decode()

# Iterate processes
processLines = ps.split("\n")
sep = re.compile("[\s]+")
rssTotal = 0 # KiB
for row in range(1,len(processLines)):
  rowText = processLines[row].strip()
  rowElements = sep.split(rowText)
  try:
    rss = float(rowElements[0]) * 1024
  except:
    rss = 0
  rssTotal += rss

# Process vm_stat
vmLines = vm.split("\n")
sep = re.compile(":[\s]+")
vmStats = {}
for row in range(1,len(vmLines)-2):
  rowText = vmLines[row].strip()
  rowElements = sep.split(rowText)
  vmStats[(rowElements[0])] = int(rowElements[1].strip("\.")) * 4096

print("Wired Memory:\t\t%d MiB" % ( vmStats["Pages wired down"]/1024/1024 ))
print(("Active Memory:\t\t%d MiB" % ( vmStats["Pages active"]/1024/1024 )))
print(("Inactive Memory:\t%d MiB" % ( vmStats["Pages inactive"]/1024/1024 )))
print(("Free Memory:\t\t%d MiB" % ( vmStats["Pages free"]/1024/1024 )))
print(("Real Mem Total (ps):\t%.3f MiB" % ( rssTotal/1024/1024 )))
