# [Internal Documentation] Automated SC-MCC Test Case Generation using Bounded Model Checking.

<table width="100%">
  <tr>
    <td><strong>Authors :</strong> <b>Golla Monika Rani</b> and <b>Sangharatna Godboley</b>. </td>
    <td align="right"><strong>Last Updated:</strong> 26-01-2025</td>
  </tr>
</table>

This document provides step-by-step instructions to install the required tools and dependencies and run SC MCC CBMC in your ubuntu system.

---
## Introduction 

**SC MCC CBMC** is a verification and analysis tool designed to assess software safety and correctness. It combines the power of CBMC such that it integrates **CBMC (C Bounded Model Checker)** with a specialized **statechart model checking framework (MCC)** to enable robust software verification. This tool is designed to assess both the correctness of software logic and the validity of statechart models, ensuring adherence to system specifications.
CBMC is a verification tool for C and C++ programs that checks array bounds, pointer safety, exceptions, and user-specified assertions.
SC MCC extends this with a Model Checking Compiler (MCC) framework tailored for statechart verification.

SC MCC CBMC offers two distinct modes of operation:
- **Mode 1**: Functional verification at the code level, focusing on memory safety, pointer safety, and compliance with assertions.
- **Mode 2**: Statechart verification, analyzing high-level system behavior, transitions, and invariants.

By combining these approaches, SC MCC CBMC provides a comprehensive verification workflow for both low-level code and high-level models.

---

## Table of Contents
- [\[Internal Documentation\] Automated SC-MCC Test Case Generation using Bounded Model Checking.](#internal-documentation-automated-sc-mcc-test-case-generation-using-bounded-model-checking)
  - [Introduction](#introduction)
  - [Table of Contents](#table-of-contents)
  - [Tested Versions](#tested-versions)
  - [Prerequisites](#prerequisites)
  - [Step-by-Step Installation](#step-by-step-installation)
    - [Step 1: Update System](#step-1-update-system)
    - [Step 2: Install CBCMC via Package Manager (APT)](#step-2-install-cbcmc-via-package-manager-apt)
    - [Step 3: Install Java via Package Manager (APT)](#step-3-install-java-via-package-manager-apt)
    - [Step 4: Install Python3 via Package Manager (APT)](#step-4-install-python3-via-package-manager-apt)
  - [File Structure of the Codes in directory](#file-structure-of-the-codes-in-directory)
    - [CBMC Folder](#cbmc-folder)
    - [MutationAnalysis Folder](#mutationanalysis-folder)
    - [SequenceGenerator Folder](#sequencegenerator-folder)
    - [Main scripts](#main-scripts)
  - [Execution](#execution)
    - [Run Symb.c](#run-symbc)
    - [Outputs](#outputs)
      - [Mode1 Results](#mode1-results)
      - [Mode2 Results](#mode2-results)
      - [Files used while testing :](#files-used-while-testing-)
  - [Test All Programmes in a batch mode](#test-all-programmes-in-a-batch-mode)
    - [To replicate the subset of results of programs. Please run the below command which will run 5 programs. Note: It will take approx. 2 hrs.](#to-replicate-the-subset-of-results-of-programs-please-run-the-below-command-which-will-run-5-programs-note-it-will-take-approx-2-hrs)
    - [To replicate the result for all the programs. It will take huge time approx. 48+ hrs.](#to-replicate-the-result-for-all-the-programs-it-will-take-huge-time-approx-48-hrs)

---

## Tested Versions
This program has been tested on the following platforms:
- **Ubuntu 24.04 LTS**

Compatible with:
- **Java**: OpenJDK 11+
- **Python**: Python 3.8+
- **CBMC**: Ver
  
---


## Prerequisites
Ensure the following prerequisites are met before installation:
1. A Linux-based operating system (Ubuntu/Debian recommended).
2. **Administrative privileges** to install required software.
3. An active **Internet connection** for downloading dependencies.

---

## Step-by-Step Installation

### Step 1: Update System

To ensure your system is up to date, run the following commands:

```bash
sudo apt update
sudo apt upgrade -y
```

### Step 2: Install CBCMC via Package Manager (APT)

CBMC may be available in Ubuntu’s package repositories, depending on your version.
**Install cbmc:**
   - It is recommended to install cbmc using the system's package manager.
   - For Ubuntu, you can install cbmc with the following command:

 ```bash
sudo apt install cbmc
```

**Verify cbmc:**
   - After installing cbmc, verify it with the following command:
```bash
cbmc --version
```

### Step 3: Install Java via Package Manager (APT)

**Install java:**
  - Install OpenJDK 11, a popular version of Java compatible with most software:
```bash
sudo apt install openjdk-11-jdk -y
 ```
**Verify java:**
   - After installing java, verify it with the following command:
```bash
java --version
```
### Step 4: Install Python3 via Package Manager (APT)

Ubuntu usually comes with Python3 pre-installed. However, to ensure it's installed or to update to the latest version:

**Install python3:**
```bash
sudo apt install python3 python3-pip -y
```
**Verify java:**
   - After installing java, verify it with the following command:
```bash
python3 --version
```

## File Structure of the Codes in directory

### CBMC Folder
- SC-MCC/CBMC/cbmc
- SC-MCC/CBMC/goto-cc
- SC-MCC/CBMC/goto-instrument
- SC-MCC/CBMC/LICENSE
- SC-MCC/CBMC/mcdc-cbmc.sh
- SC-MCC/CBMC/PartialMetaProg.sh
- SC-MCC/CBMC/cbmc_script.sh
- SC-MCC/CBMC/scmcc-cbmc.sh

### MutationAnalysis Folder
- SC-MCC/MutationAnalysis/deadmutants.sh
- SC-MCC/MutationAnalysis/MA_SC_MCC_V2.sh
- SC-MCC/MutationAnalysis/mutator.py
- SC-MCC/MutationAnalysis/mutator.sh

### SequenceGenerator Folder
- SC-MCC/SequenceGenerator/exp/
- SC-MCC/SequenceGenerator/MCDC_Sequence_Generator_multiple.class
- SC-MCC/SequenceGenerator/MCDC_Sequence_Generator_multiple.java
- SC-MCC/SequenceGenerator/MCDC_Sequence_Generator_multiple_mcdc.class
- SC-MCC/SequenceGenerator/MCDC_Sequence_Generator_multiple_mcdc.java
- SC-MCC/SequenceGenerator/MetaJavaFileGenerator_V5.class
- SC-MCC/SequenceGenerator/MetaJavaFileGenerator_V5.java
- SC-MCC/SequenceGenerator/MetaJavaFileGenerator_V6.class
- SC-MCC/SequenceGenerator/MetaJavaFileGenerator_V6.java
- SC-MCC/SequenceGenerator/seqshell.sh
- SC-MCC/SequenceGenerator/seqshell-mcdc.sh
### Main scripts
- SC-MCC/main-scmcc.sh
- SC-MCC/README.md
- SC-MCC/run-scmcc.sh

## Execution 

### Run Symb.c
- Format <script_file> <bound_value> <version_number>
```bash
./main-scmcc.sh symb 4 2
```

### Outputs

- Below folders will be generated. Here, Mode1 folder contains the results of MC/DC whereas Mode2 folder contains SC-MCC results.
#### Mode1 Results
- SC-MCC/symb-RESULTS/Mode1/
- SC-MCC/symb-RESULTS/Mode1/CBMC/
- SC-MCC/symb-RESULTS/Mode1/PredicatesResults/
-  SC-MCC/symb-RESULTS/Mode1/symb-Mode1-Mutation/
-  SC-MCC/symb-RESULTS/Mode1/symb-Mode1-TC/
#### Mode2 Results
- SC-MCC/symb-RESULTS/Mode2/
- SC-MCC/symb-RESULTS/Mode2/CBMC/
- SC-MCC/symb-RESULTS/Mode2/meta/
- SC-MCC/symb-RESULTS/Mode2/PredicatesResults/
- SC-MCC/symb-RESULTS/Mode2/symb-Mode2-Mutation/
- SC-MCC/symb-RESULTS/Mode2/symb-Mode2-TC/
  
#### Files used while testing : 

- SC-MCC/symb-RESULTS/Mode1/CBMC/MetaWithBraces-V4.c <br>
  The file "MetaWithBraces-V4.c" of Mode1/CBMC folder contains the meta program w.r.t., MC/DC coverage criterion.
- SC-MCC/symb-RESULTS/Mode2/CBMC/MetaWithBraces-V4.c <br>
   The file "MetaWithBraces-V4.c" of Mode2/CBMC folder contains the meta program w.r.t., SC-MCC coverage criterion.
- SC-MCC/symb-RESULTS/Mode1/symb-Mode1-TC/BT1.txt <br>
  The file "BT1.txt" of Mode1/symb-Mode1-TC/ folder corresponds to the test cases obtained by executing MC/DC meta program using CBMC.
- SC-MCC/symb-RESULTS/Mode2/symb-Mode2-TC/BT1.txt
- SC-MCC/symb-RESULTS/Mode2/symb-Mode2-TC/BT2.txt <br>
  The file "BT1.txt" and “BT2.txt” of Mode2/symb-Mode2-TC/ folder corresponds to the test cases obtained by executing SC-MCC meta program using CBMC.
- SC-MCC/symb-RESULTS/Mode1/symb-Mode1-Mutation/Cov_report-symb-Mode1.txt <br>
  The file "Cov_report-symb-Mode1.txt” of Mode1/symb-Mode1-Mutation/ folder contains the gCov coverage report upon executing MC/DC meta program with its test cases.
  The report contains following results
```bash
    Function 'main'
    Lines executed:100.00% of 10
    No branches
    No calls

    File 'symb.c'
    Lines executed:100.00% of 10
    Branches executed:54.55% of 22
    Taken at least once:31.82% of 22
    Calls executed:100.00% of 5
    Creating 'symb.c.gcov'
```
- SC-MCC/symb-RESULTS/Mode2/symb-Mode2-Mutation/Cov_report-symb-Mode2.txt <br>
  The file "Cov_report-symb-Mode2.txt” of Mode2/symb-Mode2-Mutation/ folder contains the gCov coverage report upon executing SC-MCC meta program with its test cases.
  The report contains the following output
```bash
    Function 'main'
    Lines executed:100.00% of 10
    No branches
    No calls

    File 'symb.c'
    Lines executed:100.00% of 10
    Branches executed:100.00% of 22
    Taken at least once:59.09% of 22
    Calls executed:100.00% of 5
    Creating 'symb.c.gcov'
    
```
- SC-MCC/symb-RESULTS/Mode1/symb-Mode1-Mutation/symb-report.txt <br>
  The file "symb-report.txt” of Mode1/symb-Mode1-Mutation/ folder contains the Mutation analysis report w.r.t., MC/DC test cases.
```bash
    ============Mutation Score Report============
    Total number of Alive Mutants =: 69
    Total number of Killed Mutants =: 2
    Total number of Mutants =: 71
    Mutation Score =: 2%
    ============Report-Finish====================

```
- SC-MCC/symb-RESULTS/Mode2/symb-Mode2-Mutation/symb-report.txt <br>
  The file "symb-report.txt” of Mode2/symb-Mode2-Mutation/ folder contains the Mutation analysis report w.r.t., SC-MCC test cases.
```bash
    ============Mutation Score Report============
    Total number of Alive Mutants =: 48
    Total number of Killed Mutants =: 23
    Total number of Mutants =: 71
    Mutation Score =: 32%
    ============Report-Finish====================

```
- SC-MCC/symb-RESULTS/Mode1/Time-symb-MODE1.txt <br>
  The file "Time-symb-MODE1.txt” of Mode1 folder contains the Execution time information w.r.t., MC/DC criterion.
- SC-MCC/symb-RESULTS/Mode2/Time-symb-MODE2.txt <br>
  The file "Time-symb-MODE2.txt”  of Mode2 folder contains the Execution time information w.r.t., SC-MCC criterion.

## Test All Programmes in a batch mode
### To replicate the subset of results of programs. Please run the below command which will run 5 programs. Note: It will take approx. 2 hrs.
- Such type of batch mode execution, so the testing can be evaluated in smaller time slots 
Run :
```bash
./run-scmcc-few.sh
```
 
### To replicate the result for all the programs. It will take huge time approx. 48+ hrs.
- It is recommended to manually set the slots of programs and then run. Say, batch or slot of 10 programs at a single run. You can uncomment the programs to run and comments all other programs to not to run. Note: There may be space issues if you run all 80 programs at single run. <br>
Run : 
```bash
./run-scmcc-All.sh
```

**Contact:**
For any questions and enquiry please contact below:

1. **Golla Monika Rani**, Emails: **gm720080@student.nitw.ac.in**, **gmonikarani@gmail.com**
2. **Sangharatna Godboley**, Emails: **sanghu@nitw.ac.in**, **sanghu1790@gmail.com**
