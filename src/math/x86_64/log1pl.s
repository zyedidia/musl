#include "ibt.s"

.global log1pl
.type log1pl,@function
ALIGN_ENDBRANCH64
log1pl:
	ENDBRANCH64
	mov 14(%rsp),%eax
	fldln2
	and $0x7fffffff,%eax
	fldt 8(%rsp)
	cmp $0x3ffd9400,%eax
	ja 1f
	fyl2xp1
	ret
1:	fld1
	faddp
	fyl2x
	ret
