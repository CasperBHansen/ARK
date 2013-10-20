# Her testes for ID forwarding (branch)
# Status: PASS
# ---------------------------------------------- #
#       Instruktion     |    Forventet output    #
# ---------------------------------------------- #
addiu	$s0, $0, 4      # s0: 4
addiu	$s1, $0, 6      # s1: 6
	nop             # nop's sikrer at t6 og t7
	nop             # naar at blive skrevet
	nop             # til reg foer de naeste
	nop             # operationer.
addiu	$s0, $0, 5      # s0: 5
addiu	$s1, $0, 5      # s1: 5
beq	$s0, $t7, forw  # Branch taken
	nop             # Udfoeres
	nop             # Udfoeres ikke
	nop             # Udfoeres ikke
forw:                   # Hop hertil
	nop             # Udfoeres
