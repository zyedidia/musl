#include "ibt.s"

.global log2l
.type log2l,@function
ALIGN_ENDBRANCH64
log2l:
	ENDBRANCH64
	fld1
	fldt 8(%rsp)
	fyl2x
	ret
