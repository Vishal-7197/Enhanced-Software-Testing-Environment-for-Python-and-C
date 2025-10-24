#include<stdio.h>
#define BOUND 1
int kappa;
int input,output;
#include <assert.h>
#include <math.h>
#include <stdlib.h>


int main()
{
	kappa = 0;
	for (int FLAG=0;FLAG<BOUND;FLAG++) {
        	int symb = nondet_int(); __CPROVER_input("symb",symb); 
        	int symb1 = nondet_int(); __CPROVER_input("symb1",symb1); 
        	int symb2 = nondet_int(); __CPROVER_input("symb2",symb2); 
        	int symb3 = nondet_int(); __CPROVER_input("symb3",symb3); 
        	if((symb1 != 10) && (symb1 != 6) && (symb2 != 1) && (symb2 != 8) && (symb3 != 2) || (symb3 != 5) && (symb1 != 7) && (symb2 != 9) && (symb3 != 4) && (symb != 3)){
        	printf("%d",symb);
    		}
    	}
 	return 0;
}


