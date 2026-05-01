#include "ibt.s"

.global atan2l
.type atan2l,@function
ALIGN_ENDBRANCH64
atan2l:
	ENDBRANCH64
	fldt 8(%rsp)
	fldt 24(%rsp)
	fpatan
	ret
