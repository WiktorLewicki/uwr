	.section .rodata	
mask1:
	.quad 0x5555555555555555
mask2:
	.quad 0xAAAAAAAAAAAAAAAA
mask3:
	.quad 0x3333333333333333
mask4:
	.quad 0xCCCCCCCCCCCCCCCC
mask5:
	.quad 0x0F0F0F0F0F0F0F0F
mask6:
	.quad 0xF0F0F0F0F0F0F0F0
mask7: 
	.quad 0x00FF00FF00FF00FF
mask8:
	.quad 0xFF00FF00FF00FF00
mask9:
	.quad 0x0000FFFF0000FFFF
mask10:
	.quad 0xFFFF0000FFFF0000
	.text
        .globl  bitrev
        .type bitrev, @function
bitrev:
       	movq 	%rdi, %rax	
       	shrq	$1, %rdi
       	shlq	$1, %rax
       	andq	mask1(%rip), %rdi
       	andq	mask2(%rip), %rax
       	orq	%rax, %rdi
       	
       	movq 	%rdi, %rax	
       	shrq	$2, %rdi
       	shlq	$2, %rax
       	andq	mask3(%rip), %rdi
       	andq	mask4(%rip), %rax
       	orq	%rax, %rdi
       	
       	movq 	%rdi, %rax	
       	shrq	$4, %rdi
       	shlq	$4, %rax
       	andq	mask5(%rip), %rdi
       	andq	mask6(%rip), %rax
       	orq	%rax, %rdi
       	
       	movq 	%rdi, %rax	
       	shrq	$8, %rdi
       	shlq	$8, %rax
       	andq	mask7(%rip), %rdi
       	andq	mask8(%rip), %rax
       	orq	%rax, %rdi
       	
       	movq 	%rdi, %rax	
       	shrq	$16, %rdi
       	shlq	$16, %rax
       	andq	mask9(%rip), %rdi
       	andq	mask10(%rip), %rax
       	orq	%rdi, %rax
       	
       	rorq	$32, %rax	
        ret

        .size bitrev, .-bitrev