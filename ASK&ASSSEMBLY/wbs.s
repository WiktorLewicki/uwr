.section .rodata	

mask0p:
	.quad 0xAAAAAAAAAAAAAAAA
mask0m:
	.quad 0x5555555555555555
mask1:
	.quad 0xCCCCCCCCCCCCCCCC
mask2:
	.quad 0x3333333333333333
mask3:
	.quad 0xF0F0F0F0F0F0F0F0
mask4:
	.quad 0x0F0F0F0F0F0F0F0F
mask5: 
	.quad 0xFF00FF00FF00FF00
mask6:
	.quad 0x00FF00FF00FF00FF
mask7:
	.quad 0xFFFF0000FFFF0000
mask8:
	.quad 0x0000FFFF0000FFFF
mask9:
	.quad 0xFFFFFFFF00000000
mask10:
	.quad 0x00000000FFFFFFFF
	
	
	.text
        .globl  wbs
        .type wbs, @function
wbs:
        shrq $1, %rdi
        
        
        movq %rdi, %rcx		
        movq %rdi, %rdx
        andq mask0p(%rip), %rcx
        andq mask0m(%rip), %rdx
        shrq $1, %rcx
        addq %rdx, %rcx
        
        
        movq %rdi, %rax		
        andq mask1(%rip), %rax
        andq mask2(%rip), %rdi
        shrq $2, %rax
        addq %rax, %rdi
        
        
        movq %rcx, %rdx
        andq mask1(%rip), %rcx
        shrq $1, %rcx
        addq %rcx, %rdi
        shrq $1, %rcx
        andq mask2(%rip), %rdx
        addq %rdx, %rcx
        
        
        movq %rdi, %rax		
        andq mask3(%rip), %rax
        andq mask4(%rip), %rdi
        shrq $4, %rax
        addq %rax, %rdi
        
        
        movq %rcx, %rdx
        andq mask3(%rip), %rcx
        shrq $2, %rcx
        addq %rcx, %rdi
        shrq $2, %rcx
        andq mask4(%rip), %rdx
        addq %rdx, %rcx
        
        
        
        movq %rdi, %rax		
        andq mask5(%rip), %rax
        andq mask6(%rip), %rdi
        shrq $8, %rax
        addq %rax, %rdi
        
        
        movq %rcx, %rdx
        andq mask5(%rip), %rcx
        shrq $5, %rcx
        addq %rcx, %rdi
        shrq $3, %rcx
        andq mask6(%rip), %rdx
        addq %rdx, %rcx
        
        movq %rdi, %rax		
        andq mask7(%rip), %rax
        andq mask8(%rip), %rdi
        shrq $16, %rax
        addq %rax, %rdi
        
        
        movq %rcx, %rdx
        andq mask7(%rip), %rcx
        shrq $12, %rcx
        addq %rcx, %rdi
        shrq $4, %rcx
        andq mask8(%rip), %rdx
        addq %rdx, %rcx
        
        movq %rdi, %rax		
        andq mask9(%rip), %rax
        andq mask10(%rip), %rdi
        shrq $32, %rax
        addq %rax, %rdi
        
        
        movq %rcx, %rdx
        andq mask9(%rip), %rcx
        shrq $27, %rcx
        addq %rcx, %rdi
        
        movq %rdi, %rax
	ret
        .size wbs, .-wbs