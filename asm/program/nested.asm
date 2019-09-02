# nested.asm

# ECE-151: Computer Architecture
# by Arthur Christopher Watkins
# created on 2016-05-11

# This program implements user-controlled stack pointers and recursively determines
# the summation of a number n (i.e. n + (n - 1) + (n - 2) + ... + 2 + 1).


# $sw, $lw := separate stack pointers
# $arg0 = return address
# $arg1 = number to be summed
# $arg2 = return value (watch this register for hexadecimal answer after running program)




# put number to be summed here ( > 1 , < 23 ) (keep to single line, or you MUST re-link!)
lli 0110	# load number to be summed into $mov
mtr $arg1	# move $mov (16) into $arg1
not $rrt	# not val($rrt), producing (255), store in $rrt (used for halting program after sum is calculated)
lhi 0011	# load 48 into $mov
mtr $or		# move $mov (48) into $or
lli 0000	# load 0 into $mov
mtr $sle	# move $mov (0) into $sle
or $sle		# or val($sle) with val($or), producing (48), store in $sle
lhi 0001	# load 16 into $mov
mtr $jal	# move $mov (16) into $jal
lli 0101	# load 5 into $mov
mtr $or		# move $mov (5) into $or
or $jal		# or val($jal) with val($or), producing (21), store in $jal
lli 0001	# load 1 into $mov
mtr $sge	# move $mov (1) into $sge
mtr $add	# move $mov (1) into $add
mtr $arg2	# move $mov (1) into $arg2
jal $arg0	# jump to [recursive push]; link [halt program] into $arg0


# [halt program] (summation complete)
rtm $rrt	# move $rrt (255) into $mov
mtr $jal	# move $mov (255) into $jal
jal $zero	# jump to [EOF]; halt program


# [recursive push]
sw $arg0	# store val($arg0) into Memory[val($sw)] (push return address)
rtm $sge	# move $sge (1) into $mov
mtr $add	# move $mov (1) into $add
add $sw		# add 1 to val($sw), store in $sw (increment stack pointer)
add $lw		# add 1 to val($lw), store in $lw (increment stack pointer)
sge $arg1	# If val($sge) >= val($arg1), branch to [return]
bfs $sle	# Else, continue

sw $arg1	# store val($arg1) into Memory[val($sw)] (push numerical value)
add $sw		# add 1 to val($sw), store in $sw (increment stack pointer)
add $lw		# add 1 to val($lw), store in $lw (increment stack pointer)
rtm $rrt	# move $rrt (255) into $mov
mtr $add	# move $mov (255) into $add
add $arg1	# subtract 1 from val($arg1), store in $arg1 (decrement numerical value)
lhi 0001	# load 16 into $mov
mtr $jal	# move $mov (16) into $jal
lli 0101	# load 5 into $mov
mtr $or		# move $mov (5) into $or
or $jal		# or val($jal) with val($or), producing (21), store in $jal
jal $arg0	# jump to [recursive push]; link [recursive pop and summation] into $arg0


# [recursive pop and summation]
rtm $rrt	# move $rrt (255) into $mov
mtr $add	# move $mov (255) into $add
add $sw		# subtract 1 from val($sw), store in $sw (decrement stack pointer)
add $lw		# subtract 1 from val($lw), store in $lw (decrement stack pointer)
lw $rlf		# load Memory[val($lw)] into $rlf
rtm $rlf	# move $rlf into $mov (numerical value popped off stack)
mtr $add	# move $mov into $add (numerical value popped off stack)
add $arg2	# add val($arg2) to val($add), store in $arg2 (add popped numerical value to return value)


# [return]
rtm $rrt	# move $rrt (255) into $mov
mtr $add	# move $mov (255) into $add
add $sw		# subtract 1 from val($sw), store in $sw (decrement stack pointer)
add $lw		# subtract 1 from val($lw), store in $lw (decrement stack pointer)
lw $jal		# load Memory[val($lw)] into $jal (pop return address)
jal $zero	# jump to popped return address
