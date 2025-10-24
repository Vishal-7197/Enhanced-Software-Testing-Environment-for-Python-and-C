#!/bin/ksh
echo sanghu
BENCHMARK=$1

origlocs=$(wc -l < $BENCHMARK-bmc/$BENCHMARK.sol)
modlocs=$(wc -l < $BENCHMARK-bmc/${BENCHMARK}_mod.sol)

###############Below data extraction is for BMC results##########
f1="$BENCHMARK-bmc/${BENCHMARK}_result.txt"
propB=$(grep "Properties inserted :" $f1 | sed "s/[^0-9.]*//g")
propdydetB=$(grep "Properties violation detected (dynamic) :" $f1 | sed "s/[^0-9.]*//g")
propudetB=$(grep "Properties violation detected (unique) :" $f1 | sed "s/[^0-9.]*//g")
totcondB=$(grep "Total atomic condition :" $f1 | sed "s/[^0-9.]*//g")
condcovB=$(grep "Condition Coverage % :" $f1 | sed "s/[^0-9.]*//g")
f2="$BENCHMARK-bmc/Time-${BENCHMARK}.txt"
timeB=$(grep "Total runtime in seconds" $f2 | sed "s/[^0-9.]*//g")

###############Below data extraction is for CHC results##########
f3="$BENCHMARK-chc/${BENCHMARK}_result.txt"
propC=$(grep "Properties inserted :" $f3 | sed "s/[^0-9.]*//g")
propdydetC=$(grep "Properties violation detected (dynamic) :" $f3 | sed "s/[^0-9.]*//g")
propudetC=$(grep "Properties violation detected (unique) :" $f3 | sed "s/[^0-9.]*//g")
totcondC=$(grep "Total atomic condition :" $f3 | sed "s/[^0-9.]*//g")
condcovC=$(grep "Condition Coverage % :" $f3 | sed "s/[^0-9.]*//g")
f4="$BENCHMARK-chc/Time-${BENCHMARK}.txt"
timeC=$(grep "Total runtime in seconds" $f4 | sed "s/[^0-9.]*//g")

printf "$BENCHMARK, $origlocs, $modlocs, $propB, $propdydetB, $propudetB, $totcondB, $condcovB, $timeB, $propC, $propdydetC, $propudetC, $totcondC, $condcovC, $timeC,\n" >> final-summary.csv


