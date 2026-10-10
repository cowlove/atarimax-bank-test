.text
.zeropage __atarimax_current_bank
.global __atarimax_current_bank

.weak _cart_init
_cart_init:
	lda #0
	sta __atarimax_current_bank
	sta $d500
	rts
