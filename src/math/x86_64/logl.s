#include "ibt.s"

.global logl
.type logl,@function
ALIGN_ENDBRANCH64
logl:
	ENDBRANCH64
	fldln2
	fldt 8(%rsp)
	fyl2x
	ret
