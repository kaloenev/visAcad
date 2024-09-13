#!/bin/env bash

function shared () {
	LD_LIBRARY_PATH="${PWD}:$LD_LIBRARY_PATH"
	export LD_LIBRARY_PATH
	echo "shared"
	gcc -c -fpic -Wall -Werror -O3 foo.c
	gcc -o libfoo.so  --shared -O3 foo.o
	gcc -c -fpic -Wall -Werror -O3 bar.c
	gcc -o libbar.so  --shared -O3 bar.o
	strip libfoo.so -o libfoo.so
	strip libbar.so -o libbar.so
	gcc -Wall -Werror -L${PWD} -O3 -o main_shared main.c -lfoo -lbar
	strip main_shared -o main_shared
}

function static () {
	echo "static"
	gcc -c -fpic -Wall -Werror -O3 foo.c
	gcc -c -fpic -Wall -Werror -O3 bar.c
	gcc -Wall -Werror -static -O3 -o main_static main.c foo.o bar.c
	strip main_static -o main_static
}

OPTS="s"

while getopts ${OPTS} opt; do
	case ${opt} in
	s)
		shared
		exit 0;
		;;
	esac
done

static
