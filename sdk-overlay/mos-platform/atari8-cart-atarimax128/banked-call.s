.include "imag.inc"

.macro ATARIMAX_BANK_TRAMPOLINE section, exported=0
.section \section,"ax",@progbits
.if \exported
.global atarimax_banked_call
.type atarimax_banked_call,@function
atarimax_banked_call:
.endif
	; A carries bank; callback address arrives in __rc2/__rc3.
	cmp #16
	bcs .Lbank_done_\@
	tay
	lda __atarimax_current_bank
	pha
	tya
	sta __atarimax_current_bank
	tax
	lda #0
	sta $d500,x
	lda #>(.Lafter_call_\@ - 1)
	pha
	lda #<(.Lafter_call_\@ - 1)
	pha
	jmp (__rc2)
.Lafter_call_\@:
	pla
	sta __atarimax_current_bank
	tax
	lda #0
	sta $d500,x
	rts
.Lbank_done_\@:
	rts
.endm

ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.0, 1
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.1
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.2
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.3
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.4
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.5
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.6
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.7
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.8
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.9
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.10
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.11
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.12
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.13
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.14
ATARIMAX_BANK_TRAMPOLINE .bank_trampoline.15
