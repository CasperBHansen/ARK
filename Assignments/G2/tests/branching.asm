<<<<<<< HEAD
main:
	addiu $s0, $zero, 4
	addiu $s1, $zero, 2
	jal label
	nop
	nop
	nop

label:
	beq $s0, $s1, next
	addiu $s1, $s1, 1
	jr $ra

next:
	nop
	addiu $s2, $zero, 3 # failure 
	nop
	nop
	jal end
	nop

=======
addiu	$s0, $zero, 4
addiu	$s1, $zero, 2
jal label
	nop
	nop
	nop
label:
beq	$s0, $s1, next
addiu	$s1, $s1, 1
jr	$ra
next:
	nop
addiu	$s2, $zero, 3
	nop
	nop
jal end
nop
>>>>>>> 54d0692b4fd9d585c14b8b91a7e161fc68def805
end:
	nop
