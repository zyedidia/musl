#include "ibt.s"

.text
.global __tlsdesc_static
.hidden __tlsdesc_static
.type __tlsdesc_static,@function
ALIGN_ENDBRANCH64
__tlsdesc_static:
	ENDBRANCH64
	mov 8(%rax),%rax
	ret

.global __tlsdesc_dynamic
.hidden __tlsdesc_dynamic
.type __tlsdesc_dynamic,@function
ALIGN_ENDBRANCH64
__tlsdesc_dynamic:
	ENDBRANCH64
	mov 8(%rax),%rax
	push %rdx
	mov %fs:8,%rdx
	push %rcx
	mov (%rax),%rcx
	mov 8(%rax),%rax
	add (%rdx,%rcx,8),%rax
	pop %rcx
	sub %fs:0,%rax
	pop %rdx
	ret
