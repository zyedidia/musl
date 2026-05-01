/* Copyright 2011-2012 Nicholas J. Kain, licensed under standard MIT license */
#include "ibt.s"

.global _longjmp
.global longjmp
.type _longjmp,@function
.type longjmp,@function
ALIGN_ENDBRANCH64
_longjmp:
longjmp:
	ENDBRANCH64
#if defined(CET) || defined(__LFI__)
	rdsspq %rdx
	mov %rdx,%rcx
	sub 64(%rdi),%rdx
	je 1f
	neg %rdx
	shr $3,%rdx
	add $1,%rdx
	mov $255,%ebx
2:	cmp %rbx,%rdx
	cmovb %rdx,%rbx
	incsspq %rbx
	sub %rbx,%rdx
	ja 2b
1:
#endif
	xor %eax,%eax
	cmp $1,%esi             /* CF = val ? 0 : 1 */
	adc %esi,%eax           /* eax = val + !val */
	mov (%rdi),%rbx         /* rdi is the jmp_buf, restore regs from it */
	mov 8(%rdi),%rbp
	mov 16(%rdi),%r12
	mov 24(%rdi),%r13
#ifndef __LFI__
	mov 32(%rdi),%r14
	mov 40(%rdi),%r15
#endif
	mov 48(%rdi),%rsp
	jmp *56(%rdi)           /* goto saved address without altering rsp */
