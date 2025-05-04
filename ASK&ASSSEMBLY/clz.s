clz:
	xorl	%eax, %eax
	movq	%rdi, %rdx
	shrq	$32, %rdx
	setnz	%dl
	movzbl	%dl, %edx
	shll	$5, %edx
	addl	%edx, %eax
	
	movq	%rdi, %rdx
	leal	16(%eax), %ecx
	shrq	%cl, %rdx
	setnz	%dl
	movzbl	%dl, %edx
	shll	$4, %edx
	addl	%edx, %eax
	
	
	movq	%rdi, %rdx
	leal	8(%eax), %ecx
	shrq	%cl, %rdx
	setnz	%dl
	movzbl	%dl, %edx
	shll	$3, %edx
	addl	%edx, %eax
	
	
	movq	%rdi, %rdx
	leal	4(%eax), %ecx
	shrq	%cl, %rdx
	setnz	%dl
	movzbl	%dl, %edx
	shll	$2, %edx
	addl	%edx, %eax
	
	
	movq	%rdi, %rdx
	leal	2(%eax), %ecx
	shrq	%cl, %rdx
	setnz	%dl
	movzbl	%dl, %edx
	shll	$1, %edx
	addl	%edx, %eax
	
	
	movq	%rdi, %rdx
	leal	1(%eax), %ecx
	shrq	%cl, %rdx
	setnz	%dl
	movzbl	%dl, %edx
	addl	%edx, %eax
	
	movl	$63, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	
	testq	%rdi, %rdi
	setz	%dl
	movzbl	%dl, %edx
	add	%edx, %eax
	ret
	.size	clz, .-clz