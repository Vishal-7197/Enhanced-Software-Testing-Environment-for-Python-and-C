echo monika
#!/bin/ksh
export BENCHMARK=$1
export MODE=$2

python3 mutator.py $BENCHMARK.c $BENCHMARK-Mutants
#gcc -fprofile-arcs -ftest-coverage -g ${BENCHMARK}.c

gcc --coverage ${BENCHMARK}.c -c
gcc --coverage ${BENCHMARK}.o

for q in `ls -v ../$BENCHMARK-Mode$MODE-TC/*`;
do
echo $q
./a.out < $q
done

gcov -abcfu ${BENCHMARK}.c > Cov_report-${BENCHMARK}-Mode$MODE.txt
rm a.out

#The below code is to run tests on Original Program
./deadmutants.sh $BENCHMARK
gcc ${BENCHMARK}.c
mkdir ${BENCHMARK}-Original
pwd
let a=1
for b in `ls -v ../$BENCHMARK-Mode$MODE-TC/*`; 
do 
./a.out < ${b} > op-${a}.txt
mv op-${a}.txt ${BENCHMARK}-Original
((a =a+1));
done
rm a.out

#The below code is to run tests on all mutants
let c=1
let t=0
let k=0

for y in `ls -v ${BENCHMARK}-ReachedMutants/*`;
do
gcc ${y}
if [ $? == 0 ]
then
echo "${y}: MUTANT IS COMPILABLE \n" >> Mutant-compilable-check.txt
else
echo "${y}: MUTANT IS NOT-COMPILABLE \n" >> Mutant-compilable-check.txt
fi
mkdir ${BENCHMARK}-OP-${c}
((t =t+1));
let r=1
for z in `ls -v ../$BENCHMARK-Mode$MODE-TC/*`; 
do 
./a.out < ${z} > op-${r}.txt
mv op-${r}.txt ${BENCHMARK}-OP-${c}
diff ${BENCHMARK}-Original/op-${r}.txt ${BENCHMARK}-OP-${t}/op-${r}.txt
if [ $? == 0 ]
then
echo "Mutant Alive"
else
echo "Mutant Killed"
echo $y "killed due to" $z >> killed-Mutants-report.txt
((k =k+1));
break;
fi
((r =r+1));
done
rm a.out
rm -r ${BENCHMARK}-OP-${t}
((c =c+1));
done
rm -r ${BENCHMARK}-Original
((a = ${t} - ${k} ))
((mscore = (${k} * 100) / ${t}))
echo "============Mutation Score Report============"
echo "============Mutation Score Report============" >> $BENCHMARK-report.txt
echo "Total number of Alive Mutants =: ${a}"
echo "Total number of Alive Mutants =: ${a}" >> $BENCHMARK-report.txt 
echo "Total number of Killed Mutants =: ${k}"
echo "Total number of Killed Mutants =: ${k}" >> $BENCHMARK-report.txt 
echo "Total number of Mutants =: ${t}"
echo "Total number of Mutants =: ${t}" >> $BENCHMARK-report.txt 
echo "Mutation Score =: ${mscore}%"
echo "Mutation Score =: ${mscore}%" >> $BENCHMARK-report.txt 
echo "============Report-Finish===================="
echo "============Report-Finish====================" >> $BENCHMARK-report.txt

mkdir $BENCHMARK-Mode$MODE-Mutation
mv Mutant-compilable-check.txt $BENCHMARK-Mode$MODE-Mutation
mv killed-Mutants-report.txt $BENCHMARK-Mode$MODE-Mutation
mv $BENCHMARK-report.txt $BENCHMARK-Mode$MODE-Mutation
mv $BENCHMARK-ReachedMutants $BENCHMARK-Mode$MODE-Mutation
mv $BENCHMARK-Mutants $BENCHMARK-Mode$MODE-Mutation

mkdir $BENCHMARK-Mode$MODE-Mutation/src
mv $BENCHMARK.* $BENCHMARK-Mode$MODE-Mutation/src/
mv $BENCHMARK-CoveredLines.txt $BENCHMARK-Mode$MODE-Mutation/src/
mv $BENCHMARK-ReachedMutantsList.txt $BENCHMARK-Mode$MODE-Mutation/src/

mv Cov_report-${BENCHMARK}-Mode$MODE.txt $BENCHMARK-Mode$MODE-Mutation





#gcov -abcfu PS-P2-L-T-R16-B2.c > Cov_report-PS-P2-L-T-R16-B2-Mode1.txt


#gcc -fprofile-arcs -ftest-coverage -o PS-P2-L-T-R16-B2 PS-P2-L-T-R16-B2.c

