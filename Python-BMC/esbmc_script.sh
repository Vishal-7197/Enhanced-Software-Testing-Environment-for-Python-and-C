#!/bin/bash

export BENCHMARK=$1

BENCHMARK=$(basename "$BENCHMARK" .py)

echo "********** TESTING ESBMC **********"

# Navigate to the esbmc directory
cd ~/esbmc || { echo "esbmc directory not found! Please ensure it is cloned."; exit 1; }

# Check if the virtual environment exists
if [ ! -d ".venv" ]; then
    echo "Virtual environment (.venv) does not exist! Please run install.sh first to set it up."
    exit 1
fi

# Check if the activate script exists
if [ ! -f ".venv/bin/activate" ]; then
    echo "The activation script (.venv/bin/activate) is missing! Exiting."
    exit 1
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source ./.venv/bin/activate || { echo "Failed to activate virtual environment!"; exit 1; }

# Install ast2json in the virtual environment
echo "Installing ast2json..."
pip install ast2json || { echo "Failed to install ast2json!"; exit 1; }

echo "Running ESBMC test..."
echo "File 1 ${BENCHMARK}"

./esbmc ${BENCHMARK}.py --python python3 || { echo "ESBMC test failed!"; exit 1; }

# Deactivate the virtual environment
echo "Deactivating virtual environment..."
deactivate || { echo "Failed to deactivate virtual environment!"; exit 1; }

echo "********** TESTING COMPLETED **********"s
