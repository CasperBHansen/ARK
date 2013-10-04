##########################
#                        #
#  Machine Architecture  #
#     G1 Assignment      #
#                        #
#    Casper B. Hansen    #
#        fvx507          #
#                        #
##########################

.globl main

.data

array: .space 32		# reserve 32 bytes for the test array (8 ints)

str_correct: .asciiz "Correct! \\m/\n"	# for debugging purposes
str_wrong: .asciiz "Wrong! :(\n"		# for debugging purposes
str_failed: .asciiz "Failed! :'(\n"		# for debugging purposes

#--------------------------------------------------

.text

# main procedure
main:
	
	# push the stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	# loop for testing 
	li $s0, 0
	beg_testing:
	beq $s0, 64, end_testing	# exit condition, change to test more times
	
	# print the test count
	add $a0, $s0, 1
	li $v0, 1
	syscall
	
	# print a newline
	li $a0, '\n'
	li $v0, 11
	syscall
	
	# populate the array with random numbers
	la $a0, array		# supply the array address argument
	li $a1, 8			# supply the array size argument
	li $a2, 31			# supply the upper-bound argument
	jal rand_pop		# call the random number population routine
	nop
	
	# for debugging, print the initial array
	la $a0, array		# supply the array address argument
	li $a1, 8			# supply the array size argument
	jal print_array		# call the array printing routine
	nop
	
	# call the quicksort routine
	la $a0, array		# int v[]
	li $a1, 0			# int left
	li $a2, 7			# int right
	jal qsort			# call qsort
	nop
	
	# for debugging, print the processed array
	la $a0, array		# supply the array address argument
	li $a1, 8			# supply the array size argument
	jal print_array		# call the array printing routine
	nop
	
	# for debugging purposes, we test that the array is indeed sorted
	jal test
	
	# leave the loop, if a test failed
	beq $v1, 0, failed_a_test
	add $s0, $s0, 1
	j beg_testing
	
	# notify of failure
	failed_a_test:
	li $v1, 0
	la $a0, str_failed
	li $v0, 4
	syscall
	
	end_testing:
	
	# return control to the system
	li $v0, 10			# load system call code for termination
	syscall				# execute the system call
	
	lw $s0, 0($sp)
	addi $sp, $sp, 4

#--------------------------------------------------

# quicksort: subroutine
qsort:
	# $a0:	v[]
	# $a1:	left
	# $a2:	right
	
	addi $sp, $sp, -40	# create a new stack frame
	
	sw $ra, 0($sp)		# push the return address
	
	sw $a0, 4($sp)		# push the v[] argument
	sw $a1, 8($sp)		# push the left argument
	sw $a2, 12($sp)		# push the right argument
	
	sw $s0, 16($sp)		# push $s0
	sw $s1, 20($sp)		# push $s1
	sw $s2, 24($sp)		# push $s2
	sw $s3, 28($sp)		# push $s3
	sw $s4, 32($sp)		# push $s4
	sw $s5, 36($sp)		# push $s5
	
	# l >= r is logically the same as if r < l
	blt $a2, $a1, exit		# if (right < left) simply exit
	
	# initialize saved temporaries
	move $s0, $zero			# int i;
	move $s1, $zero			# int last;
	move $s2, $zero			# int tmp;
	
	# precalculate the offsets needed
	#	$t1 = left offset
	#	$t2 = right offset
	sll $t1, $a1, 2			# calculate the left offset into the array
	sll $t2, $a2, 2			# calculate the right offset into the array
	
	# precalculate the addresses needed
	#	$s3 = &v[left]
	#	$s4 = &v[right]
	#	$s5 = &v[ (left + right) / 2 ]
	add $s3, $t1, $a0		# add the left offset to the address
	add $s4, $t2, $a0		# add the right offset to the address
	add $s5, $a1, $a2		# left + right
	srl $s5, $s5, 1			# divide it by 2
	sll $s5, $s5, 2			# calculate offset
	add $s5, $s5, $a0		# add the address of the array
	
	# tmp = v[left];
	lw $s2, 0($s3)			# load the first element of the sub-array
	
	# v[left] = v[(left + right) / 2];
	lw $t0, 0($s5)			# load the element at index (left + right) / 2
	sw $t0, 0($s3)			# and store it into v[left]
	
	# v[(left + right) / 2] = tmp;
	sw $s2, 0($s5)			# store tmp back into the middle of the array
	
	# last = left;
	move $s1, $a1
	
	# for-loop initialization
	add $s0, $a1, 1			# pre-loop statement i = left + 1

	beg_for:
	bgt $s0, $a2, end_for	# exit condition
	
	# recalculate &v[i]
	sll $t0, $s0, 2
	add $t0, $t0, $a0
	
	lw $t1, 0($t0)			# load v[i]
	lw $t2, 0($s3)			# load v[left]
	
	# if (v[i] < v[left])
	bge $t1, $t2, else		# skip if v[i] >= v[left]
	
	# ++last;
	add $s1, $s1, 1			# add one to last
	
	# recalculate &v[last]
	sll $t3, $s1, 2
	add $t3, $t3, $a0
	
	# tmp = v[last];
	lw $s2, 0($t3)
	
	# v[last] = v[i]; - reusing pre-calc. v[i]
	sw $t1, 0($t3)
	
	# v[i] = tmp;
	sw $s2, 0($t0)
	
	else:					# !( v[i] < v[left] )
	add $s0, $s0, 1			# increment the counter
	
	j beg_for				# loop back
	
	end_for:
	
	# recalculate &v[last]
	sll $t3, $s1, 2
	add $t3, $t3, $a0
	
	# tmp = v[left];
	lw $s2, 0($s3)			# assign v[left] tmp
	
	# v[left] = v[last]; - reusing pre-calc. &v[last]
	lw $t0, 0($t3)			# load the last element
	sw $t0, 0($s3)			# store it into the left-most
	
	# v[last] = tmp;
	sw $s2, 0($t3)			# store tmp into last

	# qsort(v, left, last-1);
	sub $a2, $s1, 1			# correct the right argument
	jal qsort
	nop
	
	lw $a0, 4($sp)			# restore the v[] argument
	lw $a1, 8($sp)			# restore the left argument
	lw $a2, 12($sp)			# restore the right argument 
	
	# qsort(v, last+1, right);
	add $a1, $s1, 1			# correct the left argument
	jal qsort
	nop
	
	lw $ra, 0($sp)			# restore the return address
	
	lw $a0, 4($sp)			# restore the v[] argument
	lw $a1, 8($sp)			# restore the left argument
	lw $a2, 12($sp)			# restore the right argument
	
	lw $s0, 16($sp)			# restore $s0
	lw $s1, 20($sp)			# restore $s1
	lw $s2, 24($sp)			# restore $s2
	lw $s3, 28($sp)			# restore $s3
	lw $s4, 32($sp)			# restore $s4
	lw $s5, 36($sp)			# restore $s5
	
	addi $sp, $sp, 40		# pop the stack frame
	
	exit:
	jr $ra					# return to caller

#--------------------------------------------------

rand_pop:
	# $a0:	v[]
	# $a1:	array size
	# $a2:	upper-bound on random number generator

	addi $sp, $sp, -32	# push the stack frame
	sw $ra, 0($sp)
	sw $v0, 4($sp)

	sw $a0, 8($sp)
	sw $a1, 12($sp)
	sw $a2, 16($sp)
	
	sw $t0, 20($sp)
	sw $t1, 24($sp)
	sw $t2, 28($sp)
	
	# populate the array with an unordered list of integers
	la $t0, ($a0)		# load the address of the array
	li $t1, 0			# initialize the indexing register
	move $t2, $a1		# initialize the limiting register
	mul $t2, $t2, 4		# calculate the actual limit
	
	# generate random numbers and use those to populate the array
	beg_rand:
	beq $t1, $t2, end_rand	# exit condition
	
	move $a1, $a2		# set the upper bound on the random numbers
	li $v0, 42			# load the system call code for random number generation
	syscall				# fetch the random number
	
	sw $a0, 0($t0)		# store the random number
	
	add $t1, $t1, 4		# increment the address offset counter
	add $t0, $t0, 4
	j beg_rand			# loop back
	end_rand:
	
	lw $ra, 0($sp)
	lw $v0, 4($sp)

	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a2, 16($sp)
	
	lw $t0, 20($sp)
	lw $t1, 24($sp)
	lw $t2, 28($sp)
	
	addi $sp, $sp, 32	# pop the stack frame
	
	jr $ra

#--------------------------------------------------

# print_array: prints a fancily formatted array, for debugging purposes
print_array:
	# $a0:	v[]
	# $a1:	array size
	
	addi $sp, $sp, -28	# push the stack frame
	
	sw $ra, 0($sp)
	sw $v0, 4($sp)

	sw $a0, 8($sp)
	sw $a1, 12($sp)
	
	la $t0, ($a0)		# load the address of the array
	li $t1, 0			# initialize the indexing register
	move $t2, $a1			# initialize the limiting register
	mul $t2, $t2, 4		# calculate the actual limit
	
	li $a0, '['
	li $v0, 11
	syscall
	
	# print each element of the array
	beg_print:
	beq $t1, $t2, end_print	# exit condition
	
	lw $a0, 0($t0)		# set the integer to be printed
	li $v0, 1			# load the system call code for random number generation
	syscall				# fetch the random number
	
	add $t1, $t1, 4		# increment the address offset counter
	add $t0, $t0, 4
	
	beq $t1, $t2, no_comma
	li $a0, ','
	li $v0, 11
	syscall
	
	no_comma:
	j beg_print			# loop back
	end_print:

	li $a0, ']'
	li $v0, 11
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	lw $ra, 0($sp)
	lw $v0, 4($sp)

	lw $a0, 8($sp)
	lw $a1, 12($sp)
	
	lw $t0, 16($sp)
	lw $t1, 20($sp)
	lw $t2, 24($sp)
	
	addi $sp, $sp, 28	# pop the stack frame
	
	jr $ra


test:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	
	li $v1, 1
	
	li $t0, 0
	beg_test:
	beq $t0, 6, end_test
	
	sll $t1, $t0, 2
	add $t1, $t1, $a0
	lw $t1, 0($t1)
	
	sll $t2, $t0, 2
	add $t2, $t2, $a0
	lw $t2, 0($t2)
	
	bgt $t1, $t2, wrong
	
	add $t0, $t0, 1
	j beg_test
	
	wrong:
	li $v1, 0
	la $a0, str_wrong
	li $v0, 4
	syscall
	j end
	
	end_test:
	
	la $a0, str_correct
	li $v0, 4
	syscall
	
	end:
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra
