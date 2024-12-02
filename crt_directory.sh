#!/bin/bash

#checking thre arguments are provided or not
if [ $# -ne 3 ]; then 
    echo "Usage: $0 day 1 90"
    exit 1
fi 

#Assigning arguments to variable 
dir_name=$1
start_num=$2
end_num=$3

#create directories using a loop
for ((i=start_num; i<=end_num; i++))
do
    mkdir "${dir_name}${i}"
done 
echo "Directories created from ${dir_name}${start_num}${end_num}"    