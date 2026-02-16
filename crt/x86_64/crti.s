.section .init
.global _init
.p2align 5
_init:
  endbr64
	push %rax
	.p2align 5

.section .fini
.global _fini
.p2align 5
_fini:
  endbr64
	push %rax
	.p2align 5
