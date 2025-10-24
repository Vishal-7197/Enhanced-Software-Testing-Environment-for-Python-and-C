#!/bin/bash

export FILEPATH=$1
export MODE=$2
export DURATION=$3

START_TIME=$(date +%s.%N)

if [ $FILEPATH =~ '*.sol' ] then
    echo "Error: Not a Smart Contract file."
    exit
fi

FILENAME_NOEXT=$(basename "$FILEPATH" .sol)
FILENAME_EXT="${FILENAME_NOEXT}.sol"
SAVE_FOLDER="${FILENAME_NOEXT}_Results_${MODE}"

if [ ! -f $FILENAME_EXT ] then
    echo "Error: Given file doesn't exist."
    exit
fi

mkdir -p SAVE_FOLDER

# Removing comments from Smart Contract - need to implement
g++ Comment_Remover.cpp -o Comment_Remover
./Comment_Remover $FILENAME_NOEXT

# Assertion Injector part - need to implement

if [[ $MODE == "bmc" ]] then
    timeout $DURATION solc <infile> \
    --model-checker-engine bmc --model-checker-targets assert \
    &> <outfile>
    
    sed -i 's/Warning: BMC:/CheckPoint\nWarning: BMC:/g' <outfile>
    sed -n '/Warning: BMC: Assertion violation happens here./, /CheckPoint/p' \
    <outfile> &> <final-outfile>
fi

if [[ $MODE == "chc" ]] then
    timeout $DURATION solc <infile> \
    --model-checker-engine chc --model-checker-targets assert \
    &> <outfile>
    
    sed -i 's/Warning: CHC:/CheckPoint\nWarning: CHC:/g' <outfile>
    sed -n '/Warning: CHC: Assertion violation happens here./, /CheckPoint/p' \
    <outfile> &> <final-outfile>
fi

grep "assert" <final-outfile> > <grep-outfile>
cut -d "|" -f 1 <grep-outfile> > <cut-outfile>
sort -n -u <cut-outfile> > <sort-outfile>
sort -n <grep-outfile> > <total-assertions-outfile>
sort -n -u <total-assertions-outfile> > <unique-assertions-outfile>
grep "assert" <infile> > <assertions-inserted-outfile>

dynamic=`wc -l < <cut-outfile>`
uniq=`wc -l <sort-outfile>`



END_TIME=$(date +%s.%N)
