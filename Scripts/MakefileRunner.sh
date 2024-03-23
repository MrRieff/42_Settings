#!/bin/zsh

build() {
    if [ -z "$1" ]; then
        echo "Usage: build <filename.c>"
        return 1
    fi

    filename="$1"
    base_filename="${filename%.*}"

    cc -Wall -Wextra -Werror "$filename" && echo "File Compiled Sucessfuly\n" && echo "Output:\n\n" && ./a.out
}

