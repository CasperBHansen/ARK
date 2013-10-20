# Her testes for branch hazard stalling.
# Status: PASS
# ---------------------------------------------- #
#       Instruktion     |    Forventet output    #
# ---------------------------------------------- #
addiu	$s0, $zero, 7    # s0: 7
sw	$s0, 0($0)
addiu	$t1, $zero, 7    # t1: 7
lw	$t2, 0($0)       # t2: 7
beq	$t1, $t5, hazard # Branch taken 
	nop              # Denne operation udfoeres
	nop              # Udfoeres ikke
	nop              # Udfoeres ikke
hazard:                  # Branch hertil
	nop              # Udfoeres

