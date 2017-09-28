# This test program loads two immediate values
# and prints the sum using a syscall.

.global __start     # export start symbol
.text

__start:            # define entry point for gcc
li $t0, 1
li $t1, 2

li $v0, 1       # setup for print integer syscall
add $a0, $t1, $t0   # syscall prints value in a0
syscall

li $v0, 10      # exit syscall
syscall
