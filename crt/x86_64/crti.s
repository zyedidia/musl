#include "ibt.s"

.section .init
.global _init
ALIGN_ENDBRANCH64
_init:
	ENDBRANCH64
	push %rax
    .p2align 5

.section .fini
.global _fini
ALIGN_ENDBRANCH64
_fini:
	ENDBRANCH64
	push %rax
    .p2align 5
