#include "ibt.s"

.text
.global dlsym
.hidden __dlsym
.type dlsym,@function
ALIGN_ENDBRANCH64
dlsym:
	ENDBRANCH64
	mov (%rsp),%rdx
	jmp __dlsym
