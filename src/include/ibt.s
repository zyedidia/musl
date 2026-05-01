#if defined(CET) || defined(__LFI__)
	.macro ALIGN_ENDBRANCH64
		.p2align 5
	.endm
	.macro ENDBRANCH64
		endbr64
	.endm
#else
	.macro ALIGN_ENDBRANCH64
	.endm
	.macro ENDBRANCH64
	.endm
#endif
