/* Copyright 2011-2012 Nicholas J. Kain, licensed under standard MIT license */
#include "ibt.s"

.text
.global __set_thread_area
.hidden __set_thread_area
.type __set_thread_area,@function
ALIGN_ENDBRANCH64
__set_thread_area:
	ENDBRANCH64
	mov %rdi,%rsi           /* shift for syscall */
	movl $0x1002,%edi       /* SET_FS register */
	movl $158,%eax          /* set fs segment to */
	syscall                 /* arch_prctl(SET_FS, arg)*/
	ret
