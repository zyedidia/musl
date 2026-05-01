#include "ibt.s"

.section .init
ALIGN_ENDBRANCH64
	ENDBRANCH64
	pop %rax
	ret

.section .fini
ALIGN_ENDBRANCH64
	ENDBRANCH64
	pop %rax
	ret
