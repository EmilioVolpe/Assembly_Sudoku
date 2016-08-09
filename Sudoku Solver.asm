#Emilio Volpe
#CSE 3666 Fall 2015
#Functions and Recursion Program #4
###################################

Maze_Solver:
#Error checking (not working right now commented out temporarily)
blt $a0, 0x10000000, ERROR	#Check if a0 is equal to -1 if so go to error
srl $t0, $a0, 2				#Check through bitwise operations if out of range
sll $t0, $t0, 2 			#Check through bitwise operations if out of range
bne $a0, $t0, ERROR			#Go to error if it is out of range
addiu $sp, $sp, -24     	#Initialize the stack with 6 spaces

#Push all variables onto the stack
sw $a0, 0($sp)			#$a0 is the address of the maze object
sw $a1, 4($sp)			#$a1 is the x-value of the direction
sw $a2, 8($sp)			#$a2 is the y-value of the direction
sw $a3, 12($sp)			#$a3 is the previous direction
sw $ra, 20($sp)			#$ra is the return address; which has the location to return to
jal maze_get			# Call maze_get to Get directions in $v0
sw $v0, 16($sp)			# Push directions onto the stack into space 16

#And Comparison directions & number to check for Exit case
andi $t0, $v0, 16       # $t0 = directions & 16
bne $t0, 0, Exit		# if $t0 = true go to Exit Case
jal Up
          
#Different Cases
Exit:
li $a0, 0				#Parameter for add_head $a0 = null
li $a1, 88				#Parameter for add_head $a1 = "X"
jal add_head			#Call add_head(null, "X")			
lw $ra, 20($sp)			#Load ra
addiu $sp, $sp, 24		#Pop stack
jr $ra					

Up:
lw $a3, 12($sp)			#$a3 gets loaded with the value of $a3 in the stack
andi $t0, $v0, 8		#$t0 = directions && 8
bne $t0, 8, Down		#if $t0 is false, go to down
beq $a3, 8, Down		#If $a3 = 8 go down
lw $a0, 0($sp)			#Get the maze object
lw $a1, 4($sp)			#Get the x value
lw $a2, 8($sp) 			#Get the y value
addi $a2, $a2, 1 		#$a2 = $a2 + 1  : y = y + 1
li $a3, 4 				#$a3 = 4 : previous_directions = 4
jal Maze_Solver 		#Recursively call Maze_Solver(m,x,y+1,4)
move $a0, $v0           #$a0 = $v0
beq $v0, 0, Down        #If $v0 is null go to the next case
li $a1, 85				#Parameter for add_head $a1 = "U"
jal add_head			#Call add_head
lw $ra, 20($sp)			#Pop Ra
addiu $sp, $sp, 24		#Pop whole stack
jr $ra

Down:
lw $a3, 12($sp)			#$a3 gets loaded with the value of $a3 in the stack
andi $t0, $v0, 4		#$t0 = directions && 4
bne $t0, 4, Left		# if $t0 is false, go to Left
beq $a3, 4, Left		#If $a3 = 4 go Left
lw $a0, 0($sp)			#Get the maze object
lw $a1, 4($sp)			#Get the x value
lw $a2, 8($sp) 			#Get the y value
sub $a2, $a2, 1 		#$a2 = $a2 - 1  : y = y - 1
li $a3, 8 				#$a3 = 2 : previous_directions = 2
jal Maze_Solver 		#Recursively call Maze_Solver(m,x,y-1,8)
move $a0, $v0           #$a0 = $v0
beq $v0, 0, Left        #If $v0 is null go to the next case
li $a1, 68				#Parameter for add_head $a1 = "D"
jal add_head			#Call add_head
lw $ra, 20($sp)			#Load Return Adress
addiu $sp, $sp, 24		#Pop Stack
jr $ra

Left:
lw $a3, 12($sp)			#$a3 gets loaded with the value of $a3 in the stack
andi $t0, $v0, 2		#$t0 = directions && 4
bne $t0, 2, Right		#if $t0 is false, go to Right
beq $a3, 2, Right		#If $a3 = 2 go down
lw $a0, 0($sp)			#Get the maze object
lw $a1, 4($sp)			#Get the x value
lw $a2, 8($sp) 			#Get the y value
sub $a1, $a1, 1 		#$a1 = $a1 - 1  : x = x - 1
li $a3, 1 				#$a3 = 1 : previous_directions = 1
jal Maze_Solver 		#Recursively call Maze_Solver(m,x-1,y,1)
move $a0, $v0           #$a0 = $v0
beq $v0, 0, Right       #If $v0 is null go to the next case
li $a1, 76				#Parameter for add_head $a1 = "L"
jal add_head			#Call add_head
lw $ra, 20($sp)			#Load Return Adress
addiu $sp, $sp, 24		#Pop Stack
jr $ra

Right:
lw $a3, 12($sp)			#$a3 gets loaded with the value of $a3 in the stack
andi $t0, $v0, 1		#$t0 = directions && 1
bne $t0, 1, FAIL		#if $t0 is false, go to FAIL
beq $a3, 1, FAIL		#If $a3 = 1 go to Fail
lw $a0, 0($sp)			#Get the maze object
lw $a1, 4($sp)			#Get the x value
lw $a2, 8($sp) 			#Get the y value
addi $a1, $a1, 1 		#$a1 = $a1 + 1  : x = x + 1
li $a3, 2 				#$a3 = 2 : previous_directions = 2
jal Maze_Solver 		#Recursively call Maze_Solver(m,x+1,y,2)
move $a0, $v0           #$a0 = $v0
beq $v0, 0, Down        #If $v0 is null go to the next case
li $a1, 82				#Parameter for add_head $a1 = "R"
jal add_head			#Call add_head
lw $ra, 20($sp)			#Load Return Adress
addiu $sp, $sp, 24		#Pop Stack
jr $ra

FAIL:
li $v0, 0 				#Load 0 into output for failure
lw $ra, 20($sp)			#Load Return Adress
addi $sp, $sp, 24		#Pop stack
jr	$ra
 
ERROR:
li $v0, -1				#$v0 = -1
jr $ra



