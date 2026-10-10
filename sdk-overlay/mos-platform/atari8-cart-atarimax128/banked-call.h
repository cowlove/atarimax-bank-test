#ifndef LLVM_MOS_ATARI8_CART_ATARIMAX128_BANKED_CALL_H
#define LLVM_MOS_ATARI8_CART_ATARIMAX128_BANKED_CALL_H

#include <stdint.h>

#define ATARIMAX_BANK(bank) __attribute__((section(".bank" #bank), noinline))

__attribute__((leaf, callback(2)))
void atarimax_banked_call(uint8_t bank, void (*function)(void));

#endif
