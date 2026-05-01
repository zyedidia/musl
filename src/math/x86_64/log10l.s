#include "ibt.s"

.global log10l
.type log10l,@function
ALIGN_ENDBRANCH64
log10l:
	ENDBRANCH64
	fldlg2
	fldt 8(%rsp)
	fyl2x
	ret
