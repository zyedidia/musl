#include "ibt.s"

.global atanl
.type atanl,@function
ALIGN_ENDBRANCH64
atanl:
	ENDBRANCH64
	fldt 8(%rsp)
	fld1
	fpatan
	ret
