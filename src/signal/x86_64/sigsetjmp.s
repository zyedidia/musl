#include "ibt.s"

.global sigsetjmp
.global __sigsetjmp
.type sigsetjmp,@function
.type __sigsetjmp,@function
ALIGN_ENDBRANCH64
sigsetjmp:
__sigsetjmp:
	ENDBRANCH64
	test %esi,%esi
	jz 1f

	popq 72(%rdi)
	mov %rbx,72+8(%rdi)
	mov %rdi,%rbx

	call setjmp@PLT

	pushq 72(%rbx)
	mov %rbx,%rdi
	mov %eax,%esi
	mov 72+8(%rbx),%rbx

.hidden __sigsetjmp_tail
	jmp __sigsetjmp_tail

1:	jmp setjmp@PLT
