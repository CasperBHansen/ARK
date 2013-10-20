# Her testes for hukommelsesoperationerne sw og lw. 
# Status: PASS
# ---------------------------------------------- #
#       Instruktion     |    Forventet output    #
# ---------------------------------------------- #
addiu	$s0, $zero, 3   #  s0: 3
addiu	$s1, $zero, 4   #  s1: 4
sw	$s0, 0($0)	#  MEM 000000: 3
sw	$s1, 4($0)	#  MEM 000004: 4
lw	$t0, 0($0)	#  t0: 3
lw	$t1, 4($0)	#  t1: 4
