#!/bin/bash
export BENCHMARK=$1

cd VeriSol
BENCHMARK=$(basename "$BENCHMARK" .sol)

Dres1=$(date +%s.%N)
let dtD=0

if [ "$BENCHMARK" == "" ]
then
echo "Error: Please provide the name of Smart Contract under verification ."
exit
fi
contractFileName="${BENCHMARK}.sol"
rmvdCmntFile="${BENCHMARK}_wdoutcmnt.sol"


if [ ! -f $contractFileName ]
then
echo "Error: Given file doesn't exist ."
exit
fi
if [ ! -d "Results" ]
then
mkdir Results
fi
if [ ! -d ./Results/$BENCHMARK-$2 ]
then
mkdir ./Results/$BENCHMARK-$2
fi 
SainitizedContract="${BENCHMARK}_Sanitized.sol";
InterMediateFile="${BENCHMARK}_Intermediate.sol"
#g++ Comment_Remover.cpp -o .cmntrmv
./.cmntrmv $BENCHMARK
rm $InterMediateFile
mv  $SainitizedContract ./Results/$BENCHMARK-$2/$contractFileName
#cp $contractFileName ./Results/$BENCHMARK-$2/$contractFileName
#g++ assertionInjector.cpp -o .assertinserter
assertionInsertCount=`./.assertinserter ./Results/$BENCHMARK-$2/$BENCHMARK`
modifiedFile="${BENCHMARK}_mod.sol"
resultFile="${BENCHMARK}_output.txt"

if [ "$2" == "bmc" ]
then
timeout $3 solc ./Results/$BENCHMARK-$2/$modifiedFile --model-checker-engine bmc --model-checker-targets assert &>./Results/$BENCHMARK-$2/$resultFile
sed -i 's/Warning: BMC:/CheckPoint\nWarning: BMC:/g' ./Results/$BENCHMARK-$2/$resultFile
outputfile="${BENCHMARK}_Final_Output.txt";
sed -n '/Warning: BMC: Assertion violation happens here./, /CheckPoint/p' ./Results/$BENCHMARK-$2/$resultFile &> ./Results/$BENCHMARK-$2/$outputfile
fi

if [ "$2" == "chc" ]
then
timeout $3 solc ./Results/$BENCHMARK-$2/$modifiedFile --model-checker-engine chc --model-checker-targets assert &>./Results/$BENCHMARK-$2/$resultFile
sed -i 's/Warning: CHC:/CheckPoint\nWarning: CHC:/g' ./Results/$BENCHMARK-$2/$resultFile
outputfile="${BENCHMARK}_Final_Output.txt";
sed -n '/Warning: CHC: Assertion violation happens here./, /CheckPoint/p' ./Results/$BENCHMARK-$2/$resultFile &> ./Results/$BENCHMARK-$2/$outputfile
fi

grep "assert" ./Results/$BENCHMARK-$2/$outputfile > ./Results/$BENCHMARK-$2/.grep_result.txt
cut -d "|" -f 1 ./Results/$BENCHMARK-$2/.grep_result.txt > ./Results/$BENCHMARK-$2/.cut_result.txt
sort -n -u ./Results/$BENCHMARK-$2/.cut_result.txt  > ./Results/$BENCHMARK-$2/.sort_result.txt
sort -n  ./Results/$BENCHMARK-$2/.grep_result.txt > ./Results/$BENCHMARK-$2/Total_Assertions.txt
sort -n -u ./Results/$BENCHMARK-$2/Total_Assertions.txt > ./Results/$BENCHMARK-$2/Unique_Assertions.txt
grep "assert" ./Results/$BENCHMARK-$2/$modifiedFile  >./Results/$BENCHMARK-$2/Assertions_Insertesd.txt
dynamic=`wc -l < ./Results/$BENCHMARK-$2/.cut_result.txt`
uniq=`wc -l < ./Results/$BENCHMARK-$2/.sort_result.txt`
let atomiccondition=$assertionInsertCount/2
#let conditioncoverage=($uniq/$assertionInsertCount)*100
conditioncoverage=$(($uniq*100/$assertionInsertCount))
echo "Properties inserted : ${assertionInsertCount}"
echo "Properties violation detected (dynamic) : ${dynamic}"
echo "Properties violation detected (unique) : ${uniq}"
echo "Total atomic condition : ${atomiccondition}"
echo "Condition Coverage % : ${conditioncoverage}"
finalOutput="${BENCHMARK}_result.txt"
if [ -f ./Results/$BENCHMARK-$2/$finalOutput ]
then
rm ./Results/$BENCHMARK-$2/$finalOutput
fi
echo "Properties inserted : ${assertionInsertCount}" >> ./Results/$BENCHMARK-$2/$finalOutput
echo "Properties violation detected (dynamic) : ${dynamic}" >> ./Results/$BENCHMARK-$2/$finalOutput
echo "Properties violation detected (unique) : ${uniq}" >> ./Results/$BENCHMARK-$2/$finalOutput
echo "Total atomic condition : ${atomiccondition}" >> ./Results/$BENCHMARK-$2/$finalOutput
echo "Condition Coverage % : ${conditioncoverage}" >> ./Results/$BENCHMARK-$2/$finalOutput
Dres2=$(date +%s.%N)
dtD=$(echo "$Dres2 - $Dres1" | bc)
ddD=$(echo "$dtD/86400" | bc)
dtD2=$(echo "$dtD-86400*$ddD" | bc)
dhD=$(echo "$dtD2/3600" | bc)
dtD3=$(echo "$dtD2-3600*$dhD" | bc)
dmD=$(echo "$dtD3/60" | bc)
dsD=$(echo "$dtD3-60*$dmD" | bc)
echo "****************Time Analysis Report - Start**************************" >> Time-$BENCHMARK.txt
echo "***Total runtime in seconds" $dtD >> Time-$BENCHMARK.txt
printf "Total runtime: %d:%02d:%02d:%02.4f\n" $ddD $dhD $dmD $dsD >> Time-$BENCHMARK.txt
echo "****************Time Analysis Report - End**************************" >> Time-$BENCHMARK.txt
cat Time-$BENCHMARK.txt
mv Time-$BENCHMARK.txt ./Results/$BENCHMARK-$2/
