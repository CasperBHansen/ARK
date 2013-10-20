# Vi starter med nogle simple tests af de aritmetiske operationer.
# I det foelgende udregnes ((3 + 4) + 7) - 3.
# Status: PASS
# ---------------------------------------------- #
#       Instruktion     |    Forventet output    #
# ---------------------------------------------- #
addiu	$s0, $zero, 3   #  s0: 3
addiu	$s1, $zero, 4   #  s1: 4
addiu	$s2, $zero, 7   #  s2: 7
addiu	$s3, $zero, 1   #  s3: 1
addu	$t1, $s0, $s1   #  t1: 7
addu	$t1, $t1, $s2   #  t1: 14 (ti) / e (hex)
subu	$t2, $t1, $s0   #  t2: 11 (ti) / b (hex)
slt	$t3, $t2, $t1   #  t3: 1
slti	$t4, $s0, 4     #  t4: 1
and	$t5, $s3, $s3   #  t5: 1
andi	$t6, $t5, 0     #  t6: 0
or	$t7, $s3, $t6   #  t7: 1
ori	$t8, $t7, 0     #  t8: 0
