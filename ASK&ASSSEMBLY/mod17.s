 	.section .rodata
mask1:
	.quad 0x0F0F0F0F0F0F0F0F
mask2:
	.quad 0x0F000F000F000F00
mask3:
	.quad 0x000F000F000F000F
mask4:
	.quad 0x00FF000000FF0000
mask5:
	.quad 0x000000FF000000FF
mask6:
	.quad 0x0000FFFF00000000
mask7: 
	.quad 0x000000000000FFFF

	.text
        .globl  mod17
        .type   mod17, @function
mod17:
        movq 	%rdi, %rsi
        andq	mask1(%rip), %rsi
        movq	%rsi, %rcx
        andq	mask2(%rip), %rsi
        andq	mask3(%rip), %rcx
        shrq	$8, %rsi
        addq	%rcx, %rsi
        movq	%rsi, %rcx
        andq	mask4(%rip), %rsi
        andq	mask5(%rip), %rcx
        shrq	$16, %rsi
        addq	%rcx, %rsi
        movq	%rsi, %rcx
        andq	mask6(%rip), %rsi
        andq	mask7(%rip), %rcx
        shrq	$32, %rsi
        addq	%rcx, %rsi
	shrq	$4, %rdi
        andq	mask1(%rip), %rdi
        movq	%rdi, %rcx
        andq	mask2(%rip), %rdi
        andq	mask3(%rip), %rcx
        shrq	$8, %rdi
        addq	%rcx, %rdi
        movq	%rdi, %rcx
        andq	mask4(%rip), %rdi
        andq	mask5(%rip), %rcx
        shrq	$16, %rdi
        addq	%rcx, %rdi
        movq	%rdi, %rcx
        andq	mask6(%rip), %rdi
        andq	mask7(%rip), %rcx
        shrq	$32, %rdi
        addq	%rcx, %rdi
        
       	movq	%rsi, %rax
       	subq 	%rdi, %rax
	.sub_loop:
	    cmpq    $17, %rax 
	    jl     .add_loop
	    subq    $17, %rax
	    jmp     .sub_loop

	.add_loop:
	    cmpq    $0, %rax  
	    jge     .done
	    addq    $17, %rax
	    jmp     .add_loop

	.done:
    	ret

        .size   mod17, .-mod17