__asm__(
".text \n"
".global " START " \n"
#if defined(CET) || defined(__LFI__)
".p2align 5 \n"
#endif
START ": \n"
#if 0 && (defined(CET) || defined(__LFI__))
"	endbr64 \n"
"	mov $158,%eax \n"
"	mov $0x5001,%edi \n"
"	mov $1,%esi \n"
"	syscall \n"
"	test %eax,%eax \n"
"	jnz 1f \n"
#endif
"	xor %rbp,%rbp \n"
#if defined(__LFI__) && defined(__has_feature) && __has_feature(safe_stack)
/* Under LFI+SafeStack, %rsp is the safe stack at entry (host memory, outside
 * the sandbox). The lfi-runtime placed a single 8-byte slot at the top of
 * the safe stack containing the sandbox pointer to argc on the unsafe stack.
 * Load it into %rdi so the rest of startup walks the in-sandbox argv area. */
"	mov (%rsp),%rdi \n"
#else
"	mov %rsp,%rdi \n"
#endif
".weak _DYNAMIC \n"
".hidden _DYNAMIC \n"
"	lea _DYNAMIC(%rip),%rsi \n"
"	andq $-16,%rsp \n"
"	call " START "_c \n"
#if 0 && (defined(CET) || defined(__LFI__))
"1:	ud2 \n"
#endif
);
