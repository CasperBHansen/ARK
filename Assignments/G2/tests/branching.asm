# Her testes for branching, jr og jal. 
# Status: PASS
# ---------------------------------------------- #
#       Instruktion     |    Forventet output    #
# ---------------------------------------------- #
addiu	$s0, $zero, 4   # s0: 4
addiu	$s1, $zero, 2   # s1: 2
jal label               #
	nop             # 1. og 2. gang jumpes
	nop             #   - ra: 16
	nop             #
label:                  # jump hertil
beq	$s0, $s1, stop  # tages trejde gang
addiu	$s1, $s1, 1     # Taelles op til 5
jr	$ra             # 
stop:                   # branch hertil
nop                     # stop her

