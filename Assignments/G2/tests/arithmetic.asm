addiu $s0, $zero, 3
addiu $s1, $zero, 4
addiu $s2, $zero, 7
addiu $s3, $zero, 1
addu $t1, $s0, $s1
addu $t1, $t1, $s2
subu $t2, $t1, $s0
slt $t3, $t2, $t1
slti $t4, $s0, 4
and $t5, $s3, $s3
andi $t6, $t5, 0
or $t7, $s3, $t6
ori $t8, $t7, 0
