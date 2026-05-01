__asm__(
".text \n"
".global " START " \n"
#if defined(CET) || defined(__LFI__)
".p2align 5 \n"
#endif
START ": \n"
#if defined(CET) || defined(__LFI__)
"	endbr64 \n"
"	mov $158,%eax \n"
"	mov $0x5001,%edi \n"
"	mov $1,%esi \n"
"	syscall \n"
"	test %eax,%eax \n"
"	jnz 1f \n"
#endif
"	xor %rbp,%rbp \n"
"	mov %rsp,%rdi \n"
".weak _DYNAMIC \n"
".hidden _DYNAMIC \n"
"	lea _DYNAMIC(%rip),%rsi \n"
"	andq $-16,%rsp \n"
"	call " START "_c \n"
#if defined(CET) || defined(__LFI__)
"1:	ud2 \n"
#endif
);
