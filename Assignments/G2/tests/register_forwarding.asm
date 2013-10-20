# Her testes for EXE forwarding
# Status: PASS
# ---------------------------------------------- #
#       Instruktion     |    Forventet output    #
# ---------------------------------------------- #
addiu $s0, $zero, 2    # s0: 2
addiu $s1, $zero, 3    # s1: 3
addu $s2, $s0, $s1     # s2: 5
