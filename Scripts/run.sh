#!/bin/bash

# Run make in the current directory
make

# If make succeeds, proceed to find the executable name and run it
if [ $? -eq 0 ]; then
    # Extract the first target name from the Makefile (assumes no tabs/spaces in the target line)
    program_name=$(make -n | grep -m 1 "^gcc" | sed -E 's/^.*-o ([^ ]+).*/\1/')

    if [ -z "$program_name" ]; then
        echo "Could not detect the program name!"
        exit 1
    fi

    echo "Detected program name: $program_name"

    # Run the program
    ./"$program_name"
else
    echo "Compilation failed!"
fi
