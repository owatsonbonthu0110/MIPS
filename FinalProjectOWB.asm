#Olivia Watson-Bonthu
#Final Project
#Create and code a MIPS application that asks the user for 2 integers, determines the greatest common
#divisor(GDC), and then prints the result to the console.  The GDC can be easily calculated utilizing
#the Euclidean Algorithm.
#Output should be neat and provide meaningful output text to the user including the result of the GDC 
#value for the user inputted integers.  The code should be easy to read, well commented, and follow
#all MIPS format and naming conventions.  The code must primarily execute properly with the expected
#results.
.data
	
	prompt1: 	.asciiz "\nEnter your first number: "
	prompt2:  	.asciiz "\nEnter your second number: "
	message1:  	.asciiz "\nYour first number is "
	message2:  	.asciiz "\nYour second number is "
	message3: 	.asciiz "\n\nThe greatest common divisor leaves a remainder of zero." 
	gCF: 		.asciiz "\n\nThe Greatest Common Divisor is "

.text

	main:
	#load prompts to registers
	#Prompt the user to enter number
	li $v0, 4  #4 tells system to print text
	la $a0, prompt1 #argument
	syscall
	#get the users integer
	li $v0, 5  #5 to get an integer from the keyboard
	syscall
	#store the 1st number in a1
	move $a1, $v0
	
	#Prompt user to enter second number
	li $v0, 4 #4 tells system to print text
	la $a0, prompt2 #argument
	syscall
	#get the users second integer
	li $v0, 5 #5 to get an integer from the keyboard
	syscall
	#store the 2nd number in a2
	move $a2, $v0
													
	#Display users first number
	li $v0, 4 #4 tells system to print text
	la $a0, message1 
	syscall
	#Print first number
	li $v0, 1 #to print an integer is 1
	addi $a0, $a1, 0  #add number to argument
	syscall
	
	#Display users 2nd number
	li $v0, 4 #4 tells system to print text
	la $a0, message2  
	syscall
	#Print 2nd number
	li $v0, 1 #to print an integer is 1
	addi $a0, $a2, 0  #add number to argument
	syscall
													
	#Display message3
	li $v0, 4 #4 tells system to print text
	la $a0, message3  #greatest value message
	syscall
													
	#--------------------------------------------------------------------------
	#Calculate greatest common divisor
	
	jal findGcd #jump and link -> go to callee findGcd
	move $t1, $v0 #returned values to caller here where v0 is now moved to t2
			
	#Display GCD message
	li $v0, 4 #4 tells system to print text
	la $a0, gCF
	syscall
	
	#print the value of GCD
	li $v0, 1 #to print an integer is 1
	addi $a0, $t1, 0 #GCD stored in t1 -> a0
	syscall
	
	# Tell the program that it is done
	li $v0, 10
	syscall
	
findGcd: 
	move $s1, $a1 #put a1 into s1
	move $s2, $a2 #move a2 into s2
	bgt $s2, $s1, bigNum #branch to label if s2 is greater than s1
	blt $s2, $s1, switchNum #branch to label if s2 is less than s1
	j Done #jump to Done:
bigNum:
	div $s2, $s1 #divide first one by second one if s2 was greater	
	mflo $a1 #quotient is in mflo 						
	mult $a1, $s1 #mult the quotient by the divisor 			
	mflo $t1 #answer is in mflo						
	sub $t2, $s2, $t1 #subtract t1 from s2 and store remainder in t2		
	move $a2, $t2 #move t2 into a2			
	beqz $a2, storeNumz1 #branch to label if a2 equal to zero					
	move $s2, $s1 #move s1 into s2
	move $s1, $a2 #move a2 into s1
	j bigNum #jump back to beginning of loop
	
switchNum:
	div $s1, $s2 #divide first one by 2nd one
	mflo $a1 #quotient is in mflo
	mult $a1, $s2 #mult quotient by divisor
	mflo $t1 #quotient is in mflo
	sub $t2, $s1, $t1 #subtract s1 - t1 and store remainder in t2	
	move $a2, $t2 #move remainder into a2
	beqz $a2, storeNumz2 #branch to label if a2 equal to zero
	move $s1, $s2 #move s2 into s1
	move $s2, $a2 #move a2 into s2
	j switchNum #jump back to beginning of loop
		
	Done:
	
storeNumz1:
	move $v0, $s1 #put last divisor that made it 0 remainder in v0
	jr $ra #returns to caller with values
		
storeNumz2:
	move $v0, $s2 #put last divisor that made it 0 remainder in v0
	jr $ra #returns to caller with values
		
	
	