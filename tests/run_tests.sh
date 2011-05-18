#!/bin/bash
# 
# Test script for bufstat.vim
#
# Runs all any test_*.vim in the current directory if no arguments are passed,
# otherwise only runs the tests passed as arguments.

if [ -z $1 ]; then
    tests=( test_*.vim )
else
    tests=( $* )
fi

echo "Running ${#tests[@]} tests"
echo "========"

failures=()
for i in ${tests[@]}; do
    vim -X -N -u "$i" &> /dev/null
    # vim -X -N -u "$i" 
    if [ $? -eq 0 ]; then
        echo -n "."
    else
        failures+=("$i")
        echo -n "F"
    fi
done

echo -e "\n========"

let passed=(${#tests[@]} - ${#failures[@]})

echo -n "$passed tests passed"
if [ ${#failures[@]} != 0 ]; then
    echo ", ${#failures[@]} failed."
    echo -e "\nFailures:"

    for i in ${failures[@]}; do
        echo " - $i"
    done
else
    echo
fi
