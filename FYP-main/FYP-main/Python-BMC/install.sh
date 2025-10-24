#!/bin/bash

echo "********** UPDATING SYSTEM **********"
sudo apt-get update

sudo apt-get install -y clang-14 llvm-14 clang-tidy-14 \
	 python-is-python3 python3 git ccache unzip wget curl \
	 bison flex g++-multilib linux-libc-dev libboost-all-dev \
	 libz3-dev libclang-14-dev libclang-cpp-dev cmake

echo "********** CLONING ESBMC REPO **********"
git clone https://github.com/esbmc/esbmc.git

echo "********** BUILDING ESBMC **********"
cd esbmc
mkdir build && cd build
cmake .. -DENABLE_Z3=1 -DENABLE_PYTHON_FRONTEND=On -DBUILD_TESTING=On
make -j4

echo "********** INSTALLING AST2JSON **********"
# Create a virtual environment (optional but recommended)
python -m venv .venv
source ./.venv/bin/activate
pip install ast2json
# Exit the virtual environment
deactivate

echo "********** TESTING ESBMC **********"
source ./.venv/bin/activate
cd src/esbmc
./esbmc ../../../regression/python/len/main.py --python python3
deactivate
