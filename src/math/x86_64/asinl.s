#include "ibt.s"

.global asinl
.type asinl,@function
ALIGN_ENDBRANCH64
asinl:
	ENDBRANCH64
	fldt 8(%rsp)
1:	fld %st(0)
	fld1
	fsub %st(0),%st(1)
	fadd %st(2)
	fmulp
	fsqrt
	fpatan
	ret
