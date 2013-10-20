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
