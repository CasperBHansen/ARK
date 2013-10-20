######################
##                  ##
## Test af G2.circ  ##
##     --------     ##
######################

# Bugtracker
# ----------
# - jr maa kun skrives til af JAL (der er ikke taget hoejde for forw/hasarder)
# - hvis en anden operation vil skrive til reg samtidig med JAL, er det kun
#	JAL der skrives.

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

# Her testes for data hazard stalling. 
# Status: PASS
# ---------------------------------------------- #
#       Instruktion     |    Forventet output    #
# ---------------------------------------------- #
addiu	$s0, $zero, 3   #  s0: 3
addiu	$s1, $zero, 4   #  s1: 4
sw	$s0, 0($0)	#  MEM 000000: 3
sw	$s1, 4($0)	#  MEM 000004: 4
lw	$t1, 4($0)      # t1: 4
lw	$t0, 0($0)      # t0: 3
addu	$t2, $t0, $zero # t2: 3
addu	$t3, $t1, $zero # t3: 4

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

# Her testes for EXE forwarding
# Status: PASS
# ---------------------------------------------- #
#       Instruktion     |    Forventet output    #
# ---------------------------------------------- #
addiu $s0, $zero, 2    # s0: 2
addiu $s1, $zero, 3    # s1: 3
addu $s2, $s0, $s1     # s2: 5

# Her testes for MEM forwarding (lw/sw)
# Status: PASS
# ---------------------------------------------- #
#       Instruktion     |    Forventet output    #
# ---------------------------------------------- #

# SKAL TESTES