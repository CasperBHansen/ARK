# Her testes for MEM forwarding (lw/sw)
# Status: PASS
# ---------------------------------------------- #
#       Instruktion     |    Forventet output    #
# ---------------------------------------------- #
addiu $s0, $zero, 4
sw $s0, 0($0)
lw $s1, 0($0)
sw $s2, 4($0)