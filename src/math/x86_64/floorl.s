#include "ibt.s"

.global floorl
.type floorl,@function
ALIGN_ENDBRANCH64
floorl:
	ENDBRANCH64
	fldt 8(%rsp)
1:	mov $0x7,%al
1:	fstcw 8(%rsp)
	mov 9(%rsp),%ah
	mov %al,9(%rsp)
	fldcw 8(%rsp)
	frndint
	mov %ah,9(%rsp)
	fldcw 8(%rsp)
	ret

.global ceill
.type ceill,@function
ALIGN_ENDBRANCH64
ceill:
	ENDBRANCH64
	fldt 8(%rsp)
	mov $0xb,%al
	jmp 1b

.global truncl
.type truncl,@function
ALIGN_ENDBRANCH64
truncl:
	ENDBRANCH64
	fldt 8(%rsp)
	mov $0xf,%al
	jmp 1b
