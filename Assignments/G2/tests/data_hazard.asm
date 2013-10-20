<<<<<<< HEAD
addiu $s0, $zero, 3
addiu $s1, $zero, 4
sw $s0, 0($0) # MEM 000000: 3
sw $s1, 4($0) # MEM 000004: 4
lw $t1, 4($0)
lw $t0, 0($0)
addu $t2, $t0, $zero
addu $t3, $t1, $zero
=======
addiu	$s0, $zero, 3
addiu	$s1, $zero, 4
sw	$s0, 0($0) # MEM 000000: 3
sw	$s1, 4($0) # MEM 000004: 4
lw	$t1, 4($0)
lw	$t0, 0($0)
addu	$t2, $t0, $zero
addu	$t3, $t1, $zero
>>>>>>> 54d0692b4fd9d585c14b8b91a7e161fc68def805
