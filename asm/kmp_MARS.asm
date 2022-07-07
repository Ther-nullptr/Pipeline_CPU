	.data
str: .space 512
pattern: .space 512
filename: .asciiz "C:/Users/86181/Desktop/verilog/processor_3/asm/test.dat"
	
	.text
main:
	#fopen
	la $a0, filename #load filename
	li $a1, 0 #flag
	li $a2, 0 #mode
	li $v0, 13 #open file syscall index
	syscall
	
	#read str
	move $a0, $v0 #load file description to $a0
	la $a1, str
	li $a2, 1
	li $s0, 0 #len_pattern = 0
read_str_entry:
	slti $t0, $s0, 512
	beqz $t0, read_str_exit
	li $v0, 14 #read file syscall index
	syscall
	lb $t0, 0($a1)
	addi $t1, $zero, '\n'
	beq $t0, $t1, read_str_exit
	addi $a1, $a1, 4
	addi $s0, $s0, 1
	j read_str_entry
read_str_exit:
	#read pattern
	la $a1, pattern
	li $a2, 1
	li $s1, 0 #len_pattern = 0
read_pattern_entry:
	slti $t0, $s1, 512
	beqz $t0, read_pattern_exit
	li $v0, 14 #read file syscall index
	syscall
	lb $t0, 0($a1)
	addi $t1, $zero, '\n'
	beq $t0, $t1, read_pattern_exit
	addi $a1, $a1, 4
	addi $s1, $s1, 1
	j read_pattern_entry
read_pattern_exit:
	#close file
	li $v0, 16 #close file syscall index
	syscall
	
	#call kmp
	move $a0, $s0
	la $a1, str
	move $a2, $s1
	la $a3, pattern
	jal kmp
	
	#printf
	move $a0, $v0
	li $v0, 1
	syscall
	#return 0
	li $a0, 0
	li $v0, 17
	syscall
	
kmp:
	##### your code here #####
# * params: $a0 - len_str, $a1 - str, $a2 - len_pattern, $a3 - pattern
# * return: $v0 - result
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    addi $s4, $a0, 0 # save the len_str
    addi $s5, $a2, 0 # save the len_pattern
    addi $s6, $a1, 0 # save the str
    addi $s7, $a3, 0 # save the pattern

	sll $t0, $a2, 2 # len_pattern * 4
	move $a0, $t0 # allocate len_pattern * 4 bytes for $ a0
	li $v0, 9 # allocate memory
	syscall # allocate memory
	move $s0, $v0 # save the address
	
	addi $a0, $s0, 0 # pass the address
	addi $a1, $a2, 0 # len_pattern
	addi $a2, $a3, 0 # pattern
	jal generate_next

    addi $s0, $0, 0 # i
	addi $s1, $0, 0 # j
	addi $s2, $0, 0 # cnt
	
kmp_loop:
    beq $s0, $s4, kmp_exit
    sll $t0, $s0, 2 # i*4
    sll $t1, $s1, 2 # j*4
    add $t4, $s7, $t1 # pattern+j*4
    add $t5, $s6, $t0 # str+i*4
    lw $t6, 0($t4) # pattern[j]
    lw $t7, 0($t5) # str[i]

    bne $t6, $t7, kmp_branch_1 # if pattern[j] != str[i]
    addi $t3, $s5, -1 # len_pattern - 1
    bne $s1, $t3, kmp_branch_2 # j != len_pattern - 1
    addi $s2, $s2, 1 # cnt++
    addi $t8, $s5, -1 # len_pattern - 1
    sll $t8, $t8, 2 # (len_pattern-1) * 4 
    add $t8, $t8, $s3 # next[len_pattern-1]
    lw $s1, 0($t8) # j = next[len_pattern-1]
    addi $s0, $s0, 1 # i++
    j kmp_end_if

kmp_branch_2:
    addi $s1, $s1, 1 # j++
    addi $s0, $s0, 1 # i++
    j kmp_end_if

kmp_branch_1:
    slt $t9, $0, $s1 # j > 0 1
    beq $t9, $0, kmp_branch_3  # if j < 0
    addi $t8, $s1, -1 # j - 1
    sll $t8, $t8, 2 # (j-1) * 4
    add $t8, $t8, $s3 # next[j-1]
    lw $s1, 0($t8) # j = next[j-1]
    j kmp_end_if

kmp_branch_3:
    addi $s0, $s0, 1 # i++

kmp_end_if:
    j kmp_loop

kmp_exit:
    addi $v0, $s2, 0 # return cnt
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

generate_next:
	##### your code here #####
# * params: $a0 - next, $a1 - len_pattern, $a2 - pattern
# * return: 0 or 1
# s0: pattern s1: i s2: j s3: next
    addi $sp, $sp, -12
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
	addi $s1, $0, 1 # i
	addi $s2, $0, 0 # j
	beq $a1, 0, end_1
	addi $s0, $a2, 0 # pointer of pattern
    addi $s3, $a0, 0 # pointer of next
	sw $zero, 0($s3) # next[0] = 0
next_loop:
	beq $s1, $a1, end_0
    sll $t2, $s1, 2 # 4*i
    sll $t0, $s2, 2 # 4*j
	add $t4, $s0, $t2 # pattern + i
	add $t5, $s0, $t0 # pattern + j
	lw $t4, 0($t4) # pattern[i]
	lw $t5, 0($t5) # pattern[j]
	bne $t4, $t5, next_branch_1
    addi $t0, $s2, 1 # j + 1
    add $t7, $s3, $t2 # next + 4*i
    sw $t0, 0($t7) # next[i] = j + 1
	addi $s2, $s2, 1 # j ++ 
	addi $s1, $s1, 1 # i ++ 
    j next_end_if
next_branch_1:
	slt $t6, $0, $s2 # j > 0
	beq $t6, $zero, next_branch_2
    addi $t7, $s2, -1 # j - 1
    sll $t2, $t7, 2 # 4*(j-1)
    add $t7, $s3, $t2 # next[j-1]
    lw $s2, 0($t7)
    j next_end_if
next_branch_2:
    sll $t2, $s1, 2 # i*4
    add $t7, $s3, $t2 # next + 4*i
	sw $0, 0($t7) # next[i] = 0
	addi $s1, $s1, 1 # i ++ 
next_end_if:
	j next_loop
end_1:
	addi $v0, $0, 1
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 12
	jr $ra
end_0:
    addi $v0, $0, 0
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 12
    jr $ra
