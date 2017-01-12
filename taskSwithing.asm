.data

	str0:   .asciiz "123"
	str1:   .asciiz "45678"
	
	.align 2
	tid: .space 4
	
	tcb0: .space 128
	tcb1: .space 128

.text
.globl main
main:

    la $a0, tid			#Loading tid variable address			
	addi $t0, $0, 0		#Initializing tid value
	#sw $t0, 0($a0)		#Setting tid value to tid memory address
	
	addi $sp $sp -20
	la $a1, tcb0		
	la $a2, tcb1		#Loading tcb0 and tcb1 addresses
	sw $a1, 0($sp)		#tcb0 -> S0
	sw $a2, 4($sp)		#tcb1 -> S4
	sw $t0, 8($sp)		#tid -> S8
	
		
	j task0			#Jump to task0
	
	
taskSwitch:
	
	sw $t2 16($sp)		#saving the current value of t2 to stack -> s16
	lw $t2 8($sp)		#loading the tid
	
	beq $t2 0 store0
	beq $t2 1 store1
	
	
	
	store0:
		lw $t2 16($sp)
		sw $t1 12($sp) 		#saving the current value of t1 to stack -> s12
		lw $t1 0($sp)		#getting addres of tcb0
		b store
	
	store1:
		lw $t2 16($sp)
		sw $t1 12($sp) 		#saving the current value of t1 to stack -> s12
		lw $t1 4($sp)		#getting addres of tcb1
		b store
		
		
	store:
	#TAKING SNAPSHOT OF REGISTERS
	
	sw $s0, 0($t1)
	sw $v0, 8($t1)
	sw $v1, 12($t1)
	sw $a0, 16($t1)
	sw $a1, 116($t1)
	sw $a2, 20($t1)
	sw $a3, 24($t1)
	sw $t0, 28($t1)
	sw $t2, 36($t1)		
	sw $t3, 40($t1)
	sw $t4, 44($t1)
	sw $t5, 48($t1)
	sw $t6, 52($t1)
	sw $t7, 56($t1)
	sw $s0, 60($t1)
	sw $s1, 64($t1)
	sw $s2, 68($t1)
	sw $s3, 72($t1)
	sw $s4, 76($t1)
	sw $s5, 80($t1)
	sw $s6, 84($t1)
	sw $s7, 88($t1)
	sw $t8, 92($t1)
	sw $t9, 96($t1)
	sw $k0, 100($t1)
	sw $k1, 104($t1)
	sw $s8, 108($t1)
	sw $ra, 112($t1)
	
	
	lw $a1, 12($sp)		#Saving t1 value to already stored register
	sw $a1, 32($t1)	
	 
		
	lw $t3 8($sp)		#Loading tid address -> t3
	
	beq $t3 0 load1		#If tid is 0	
	beq $t3 1 load0		#If tid is 1	
	b continue
	
	load0:
		lw $t1 0($sp) 	#Loading tcb0 address -> t1
		addi $t3 $0 0	#Setting tid to 0
		sw $t3 8($sp)	#Updating pid in stack
		b continue
		
	load1:
		lw $t1 4($sp) 	#Loading tcb1 address -> t1
		addi $t3 $0 1	#Setting tid to 1
		sw $t3 8($sp)	#Updating pid in stack
		b continue
		
	continue:
		
	#LOADING REGISTERS
	
	lw $s0, 0($t1)
	lw $v0, 8($t1)
	lw $v1, 12($t1)
	lw $a0, 16($t1)
	lw $a1, 116($t1)
	lw $a2, 20($t1)
	lw $a3, 24($t1)
	lw $t0, 28($t1)
	lw $t4, 44($t1)
	lw $t5, 48($t1)
	lw $t6, 52($t1)
	lw $t7, 56($t1)
	lw $s0, 60($t1)
	lw $s1, 64($t1)
	lw $s2, 68($t1)
	lw $s3, 72($t1)
	lw $s4, 76($t1)
	lw $s5, 80($t1)
	lw $s6, 84($t1)
	lw $s7, 88($t1)
	lw $t8, 92($t1)
	lw $t9, 96($t1)
	lw $k0, 100($t1)
	lw $k1, 104($t1)
	lw $s8, 108($t1)
	lw $ra, 112($t1)
	
	
	
	beq $t3 1 goto1		
	beq $t3 0 goto0
	
	goto0:
		lw $t2, 36($t1)		#tcb1
		lw $t3, 40($t1)		#tid
		lw $t1, 32($t1)		#tcb0
		
		beq $ra 0 noRA0
		jr $ra
		noRA0:
			j task0
	
	goto1:
		lw $t2, 36($t1)		#tcb1
		lw $t3, 40($t1)		#tid
		lw $t1, 32($t1)		#tcb0
		
		beq $ra 0 noRA1
		jr $ra
		noRA1:
			j task1
		

#------------ task0 ---------------

task0:
        add  $t0, $0, $0
	jal taskSwitch     
        addi $t1, $0, 10     
        la   $s0, str0       
	jal taskSwitch
beg0:
        lb   $t2, ($s0)     
        beq  $t2, $0, quit0 
        sub  $t2, $t2, '0'  
        mult $t0, $t1       
        mflo $t0
        add  $t0, $t0, $t2  
	jal taskSwitch
        add  $s0, $s0, 1    
        b    beg0
quit0:
	jal taskSwitch
	add  $v1, $0, $t0
	add  $s0, $0, $v1
	add  $a1, $0, $s0 
	jal taskSwitch
	add  $t5, $0, $a1
	add  $t6, $0, $t5
	addi $s0, $0, 1
	add  $v0, $0, $s0
	add  $a0, $0, $t6
	jal taskSwitch
	syscall
        j task0


#------------ task1 ---------------

task1:
        add  $t0, $0, $0    
        addi $t1, $0, 10    
        la   $s0, str1      
beg1:
        lb   $t2, ($s0)      
        beq  $t2, $0, quit1 
	jal taskSwitch
        sub  $t2, $t2, '0'  
        mult $t0, $t1
	addi $t8, $0, 0       
        addi $s5, $t8, 0       
	add  $t8, $s5, $s5       
        addi $t8, $0, 0       
        addi $s5, $t8, 0       
	add  $t8, $s5, $s5       
        mflo $t0
        add  $t0, $t0, $t2   
        add  $s0, $s0, 1     
        b    beg1
quit1:
	add  $v1, $0, $t0
	add  $s0, $0, $v1
	jal taskSwitch
	add  $a1, $0, $s0 
	add  $t5, $0, $a1
	jal taskSwitch
	add  $t6, $0, $t5
	jal taskSwitch
	addi $s0, $0, 1
	add  $v0, $0, $s0
	jal taskSwitch
	add  $a0, $0, $t6
	jal taskSwitch
	syscall
        j task1
	

