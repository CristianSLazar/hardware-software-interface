#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause

source graded_test.inc.sh

if test -z "$SRC_PATH"; then
    SRC_PATH=../support
fi

binary=$SRC_PATH/fibo_sum
log=./err.log
ERR_TESTS=0

cp $SRC_PATH/fibo_sum.asm .
: > $log

test_fibo_sum()
{
    N=$1
    SOL=$2

    # Modify the assembly code's N value
    sed -i "s/N dd [0-9]\+/N dd $N/w sedlog" $SRC_PATH/fibo_sum.asm
    if ! [ -s sedlog ] ; then
        return 2
    fi

    # Build the program
    make -s -C $SRC_PATH 2>> $log

    # Execute the program and capture the output
    output=$($binary)

    # Define the expected output
    expected_output="Sum first $N fibonacci numbers is $SOL"

    # Check if the output matches the expected output
    if [[ "$output" == "$expected_output" ]]; then
        OUT=0
    else
        OUT=1
    fi

    # Clean up object files and the executable
    make -s -C $SRC_PATH clean 2>> $log
    return $OUT
}

test_fibo_sum_1()
{
    test_fibo_sum 9 54
}
test_fibo_sum_2()
{
    test_fibo_sum 12 232
}
test_fibo_sum_3()
{
    test_fibo_sum 1 0
}
test_fibo_sum_4()
{
    test_fibo_sum 40 165580140
}

run_test "test_fibo_sum_1" 25
run_test "test_fibo_sum_2" 25
run_test "test_fibo_sum_3" 25
run_test "test_fibo_sum_4" 25

if [ $? -eq 2 ] ; then
    printf "\nERROR: Make sure the declaration of variable N in section .data follows the format \"N dd <value>\"\n"
fi

mv ./fibo_sum.asm $SRC_PATH
rm sedlog
if ! [ -s $log ] ; then
    rm $log
fi
