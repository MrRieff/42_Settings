#!/bin/bash

# Colors and styles
BOLD='\e[1m'

RED='\e[33m'
GREEN='\e[32m'
YELLOW='\e[31m'
CYAN='\e[36m'

RESET='\e[0m' # To reset color and style back to normal

echo -e "${BOLD}${GREEN}RUNNING: ${RESET}makefile..."
# Run make in the current directory
make

# If make succeeds, proceed to find the latest created file and run it
if [ $? -eq 0 ]; then
    # Find the most recently modified file in the directory (after 'make')
    program_name=$(ls -t | head -n 1)

    # Check if the detected file is executable
    if [ -x "$program_name" ]; then
        echo -e "${BOLD}${GREEN}Running: ${CYAN}$program_name"
        ./"$program_name"
    else
        echo -e "${BOLD}${CYAN} $program_name ${YELLOW} is not executable!"
    fi
else
    echo -e "${BOLD}${RED}Compilation failed!"
fi

