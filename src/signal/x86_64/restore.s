#include "ibt.s"

	nop
.global __restore_rt
.hidden __restore_rt
.type __restore_rt,@function
ALIGN_ENDBRANCH64
__restore_rt:
	ENDBRANCH64
	mov $15, %rax
	syscall
.size __restore_rt,.-__restore_rt
