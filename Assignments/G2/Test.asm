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
arithmetic:
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
memory:
sw	$s0, 0($0)	#  MEM 000000: 3
sw	$s1, 4($0)	#  MEM 000004: 4
sw	$s2, 8($0)	#  MEM 000008: 7
sw	$s3, 12($0)	#  MEM 000012: 1
lw	$t0, 0($0)	#  t0: 3
lw	$t1, 4($0)	#  t1: 4
lw	$t2, 8($0)	#  t2: 7
lw	$t3, 12($0)	#  t3: 1

# Her testes for branching, jr og jal. 
# Status: PASS
# ---------------------------------------------- #
#       Instruktion     |    Forventet output    #
# ---------------------------------------------- #
addiu	$t4, $zero, 4   # t4: 4
addiu	$t5, $zero, 2   # t5: 2
jal label               #
	nop             # 1. og 2. gang jumpes
	nop             #   - ra: 78
	nop             #
label:                  # jump hertil
beq	$t4, $t5, stop  # tages trejde gang
addiu	$t5, $t5, 1     # Taelles op til 5
jr	$ra             # 
stop:                   # branch hertil
nop                     # stop her