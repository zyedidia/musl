#define __LFI_HW_SHSTK__ 1
#define __LFI_FAKE_HW_SHSTK__ 1

/* Copyright 2011-2012 Nicholas J. Kain, licensed under standard MIT license */
.global __setjmp
.global _setjmp
.global setjmp
.type __setjmp,@function
.type _setjmp,@function
.type setjmp,@function
__setjmp:
_setjmp:
setjmp:
	mov %rbx,(%rdi)         /* rdi is jmp_buf, move registers onto it */
	mov %rbp,8(%rdi)
	mov %r12,16(%rdi)
	mov %r13,24(%rdi)
#if defined(__LFI__) && defined(__LFI_HW_SHSTK__) && defined(__LFI_FAKE_HW_SHSTK__)
	/* Fake hw-shstk: no shadow stack to save. The software SCS is not
	 * maintained in hw-shstk mode, and there is no real hardware shadow
	 * stack. Slot 32 of jmp_buf is unused. */
#elif defined(__LFI__) && defined(__LFI_HW_SHSTK__)
	xor %edx, %edx
	rdsspq %rdx              /* read hardware shadow stack pointer */
	mov %rdx, 32(%rdi)       /* store SSP in jmp_buf */
#elif defined(__LFI__)
  .lfi_rewrite_disable
	mov 16(%r15), %rdx       /* read SCS pointer directly */
  .lfi_rewrite_enable
	mov %rdx, 32(%rdi)       /* store in jmp_buf */
#else
	mov %r14,32(%rdi)
#endif
	mov %r15,40(%rdi)
	lea 8(%rsp),%rdx        /* this is our rsp WITHOUT current ret addr */
	mov %rdx,48(%rdi)
	mov (%rsp),%rdx         /* save return addr ptr for new rip */
#if defined(__LFI__) && !defined(__LFI_HW_SHSTK__)
	add $31, %rdx           /* round up to .Lret (32-byte aligned) */
	and $-32, %rdx
#endif
	mov %rdx,56(%rdi)
	xor %eax,%eax           /* always return 0 */
	ret
