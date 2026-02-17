#define __LFI_FAKE_HW_SHSTK__ 0
#define __LFI__ 1

/* Copyright 2011-2012 Nicholas J. Kain, licensed under standard MIT license */
.global _longjmp
.global longjmp
.type _longjmp,@function
.type longjmp,@function
_longjmp:
longjmp:
	xor %eax,%eax
	cmp $1,%esi             /* CF = val ? 0 : 1 */
	adc %esi,%eax           /* eax = val + !val */
#if defined(__LFI__) && __LFI_FAKE_HW_SHSTK__
	/* Fake hw-shstk: no shadow stack to unwind. */
#elif defined(__LFI__)
	/* Software SCS unwind: compute how many entries to pop from
	 * the shadow call stack to reach the state after setjmp returned.
	 * saved_scs_ptr points to setjmp's return entry on the SCS;
	 * we want to be one past it (+8), matching the post-return state. */
	mov %eax, %ecx           /* save return value */
  .lfi_rewrite_disable
	mov 16(%r15), %rsi       /* current SCS pointer */
  .lfi_rewrite_enable
	mov 32(%rdi), %rax       /* saved SCS pointer from jmp_buf */
	add $8, %rax             /* target: past setjmp's return entry */
	sub %rsi, %rax           /* byte delta */
	shr $3, %rax             /* entry count */
	mov %rdi, %rdx           /* save jmp_buf pointer */
	mov %eax, %edi           /* SCS unwind count */
	.lfi_rewrite_disable
	leaq 1f(%rip), %r11
	jmpq *48(%r14)
1:
	.lfi_rewrite_enable
	mov %rdx, %rdi           /* restore jmp_buf pointer */
	mov %ecx, %eax           /* restore return value */
#endif
	mov (%rdi),%rbx         /* rdi is the jmp_buf, restore regs from it */
	mov 8(%rdi),%rbp
	mov 16(%rdi),%r12
	mov 24(%rdi),%r13
#ifndef __LFI__
	mov 32(%rdi),%r14
#endif
	mov 40(%rdi),%r15
#if defined(__LFI__) && __LFI_FAKE_HW_SHSTK__
	/* With hardware shadow stack, no .Lret epilogue exists.
	 * Restore rsp directly and jump to the saved return address.
	 * The jump must bypass forward-edge CFI since the return site
	 * does not have endbr64 in hw-shstk mode. */
	mov 48(%rdi), %rsp
  .lfi_rewrite_disable
	jmp *56(%rdi)
  .lfi_rewrite_enable
#elif defined(__LFI__)
	/* Set up state for the .Lret epilogue inserted by the rewriter
	 * after the call to setjmp. .Lret expects %rsp = SCS pointer
	 * and 24(%r15) = real rsp. It does a popq to discard the return
	 * address pushed by callq, so subtract 8 to compensate. */
	mov 48(%rdi), %rdx       /* saved real rsp */
	sub $8, %rdx
  .lfi_rewrite_disable
	mov %rdx, 24(%r15)       /* temp slot for .Lret to restore */
	mov 16(%r15), %rsp       /* load SCS pointer into rsp */
  .lfi_rewrite_enable
	jmp *56(%rdi)            /* jump to .Lret (has endbr64) */
#else
	mov 48(%rdi),%rsp
	jmp *56(%rdi)           /* goto saved address without altering rsp */
#endif
