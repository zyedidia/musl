/* Copyright 2011-2012 Nicholas J. Kain, licensed under standard MIT license */
#include "ibt.s"

.text
.global __unmapself
.type   __unmapself,@function
ALIGN_ENDBRANCH64
__unmapself:
	ENDBRANCH64
	movl $11,%eax   /* SYS_munmap */
	syscall         /* munmap(arg2,arg3) */
	xor %rdi,%rdi   /* exit() args: always return success */
	movl $60,%eax   /* SYS_exit */
	syscall         /* exit(0) */
