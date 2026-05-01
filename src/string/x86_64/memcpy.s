#include "ibt.s"

.global memcpy
.global __memcpy_fwd
.hidden __memcpy_fwd
.type memcpy,@function
ALIGN_ENDBRANCH64
memcpy:
__memcpy_fwd:
	ENDBRANCH64
	mov %rdi,%rax
	cmp $8,%rdx
	jc 1f
	test $7,%edi
	jz 1f
2:	movsb
	dec %rdx
	test $7,%edi
	jnz 2b
1:	mov %rdx,%rcx
	shr $3,%rcx
	rep
	movsq
	and $7,%edx
	jz 1f
2:	movsb
	dec %edx
	jnz 2b
1:	ret
