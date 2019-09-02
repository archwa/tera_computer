# leaf.asm

# ECE-151: Computer Architecture
# by Arthur Christopher Watkins
# created on 2016-05-09

# This program iteratively calls a function to double a number
# until the number is greater than 48.


# [initialize]
not $rrt	# not val($rrt), producing (255), store in $rrt (used for halting program after number is greater than 48)
lhi 0011	# load 48 into $mov
mtr $sle	# move $mov (48) into $sle
lli 0111	# load 7 into $mov
mtr $jal	# move $mov (7) into $jal
lli 0001	# load 1 into $mov
mtr $add	# move $mov (1) into $add


# [double]
sle $add	# If val($sle) (48) <= val($add), 
bfs $rrt	# halt the program (jump to PC = "255")
add $add	# Else, double val($add), store in $add
jal $rlf	# jump to [double] (iteratively)
