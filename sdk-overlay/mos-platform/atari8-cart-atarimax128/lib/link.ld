/* AtariMax 128: sixteen 8 KiB banks mapped at 0xA000-0xBFFF. */

PROVIDE(__cart_rom_size = 128);

ASSERT(__cart_rom_size == 128,
       "ATARI MAX 128 cartridge: __cart_rom_size must be 128 KiB.")

MEMORY {
  zp : ORIGIN = __rc31 + 1, LENGTH = 0x100 - (__rc31 + 1)
  ram (w) : ORIGIN = 0x700, LENGTH = 0x2000 - 0x700

  bank0  : ORIGIN = 0x0100a000, LENGTH = 0x1f00
  bank1  : ORIGIN = 0x0101a000, LENGTH = 0x1f00
  bank2  : ORIGIN = 0x0102a000, LENGTH = 0x1f00
  bank3  : ORIGIN = 0x0103a000, LENGTH = 0x1f00
  bank4  : ORIGIN = 0x0104a000, LENGTH = 0x1f00
  bank5  : ORIGIN = 0x0105a000, LENGTH = 0x1f00
  bank6  : ORIGIN = 0x0106a000, LENGTH = 0x1f00
  bank7  : ORIGIN = 0x0107a000, LENGTH = 0x1f00
  bank8  : ORIGIN = 0x0108a000, LENGTH = 0x1f00
  bank9  : ORIGIN = 0x0109a000, LENGTH = 0x1f00
  bank10 : ORIGIN = 0x010aa000, LENGTH = 0x1f00
  bank11 : ORIGIN = 0x010ba000, LENGTH = 0x1f00
  bank12 : ORIGIN = 0x010ca000, LENGTH = 0x1f00
  bank13 : ORIGIN = 0x010da000, LENGTH = 0x1f00
  bank14 : ORIGIN = 0x010ea000, LENGTH = 0x1f00
  bank15 : ORIGIN = 0x010fa000, LENGTH = 0x1f00

  trampoline0  : ORIGIN = 0x0100bf00, LENGTH = 0xfa
  trampoline1  : ORIGIN = 0x0101bf00, LENGTH = 0x100
  trampoline2  : ORIGIN = 0x0102bf00, LENGTH = 0x100
  trampoline3  : ORIGIN = 0x0103bf00, LENGTH = 0x100
  trampoline4  : ORIGIN = 0x0104bf00, LENGTH = 0x100
  trampoline5  : ORIGIN = 0x0105bf00, LENGTH = 0x100
  trampoline6  : ORIGIN = 0x0106bf00, LENGTH = 0x100
  trampoline7  : ORIGIN = 0x0107bf00, LENGTH = 0x100
  trampoline8  : ORIGIN = 0x0108bf00, LENGTH = 0x100
  trampoline9  : ORIGIN = 0x0109bf00, LENGTH = 0x100
  trampoline10 : ORIGIN = 0x010abf00, LENGTH = 0x100
  trampoline11 : ORIGIN = 0x010bbf00, LENGTH = 0x100
  trampoline12 : ORIGIN = 0x010cbf00, LENGTH = 0x100
  trampoline13 : ORIGIN = 0x010dbf00, LENGTH = 0x100
  trampoline14 : ORIGIN = 0x010ebf00, LENGTH = 0x100
  trampoline15 : ORIGIN = 0x010fbf00, LENGTH = 0x100
  vector0 : ORIGIN = 0x0100bffa, LENGTH = 6
}

__rc0 = 0x80;
INCLUDE imag-regs.ld
ASSERT(__rc31 == 0x9f, "Inconsistent zero page map.")

REGION_ALIAS("c_writeable", ram)
REGION_ALIAS("c_readonly", bank0)

SECTIONS {
  INCLUDE c.ld

  .bank0  : { *(.bank0  .bank0.*)  } >bank0
  .bank1  : { *(.bank1  .bank1.*)  } >bank1
  .bank2  : { *(.bank2  .bank2.*)  } >bank2
  .bank3  : { *(.bank3  .bank3.*)  } >bank3
  .bank4  : { *(.bank4  .bank4.*)  } >bank4
  .bank5  : { *(.bank5  .bank5.*)  } >bank5
  .bank6  : { *(.bank6  .bank6.*)  } >bank6
  .bank7  : { *(.bank7  .bank7.*)  } >bank7
  .bank8  : { *(.bank8  .bank8.*)  } >bank8
  .bank9  : { *(.bank9  .bank9.*)  } >bank9
  .bank10 : { *(.bank10 .bank10.*) } >bank10
  .bank11 : { *(.bank11 .bank11.*) } >bank11
  .bank12 : { *(.bank12 .bank12.*) } >bank12
  .bank13 : { *(.bank13 .bank13.*) } >bank13
  .bank14 : { *(.bank14 .bank14.*) } >bank14
  .bank15 : { *(.bank15 .bank15.*) } >bank15

  .bank_trampoline0  0x0100bf00 : { KEEP(*(.bank_trampoline.0)) } >trampoline0
  .bank_trampoline1  0x0101bf00 : { KEEP(*(.bank_trampoline.1)) } >trampoline1
  .bank_trampoline2  0x0102bf00 : { KEEP(*(.bank_trampoline.2)) } >trampoline2
  .bank_trampoline3  0x0103bf00 : { KEEP(*(.bank_trampoline.3)) } >trampoline3
  .bank_trampoline4  0x0104bf00 : { KEEP(*(.bank_trampoline.4)) } >trampoline4
  .bank_trampoline5  0x0105bf00 : { KEEP(*(.bank_trampoline.5)) } >trampoline5
  .bank_trampoline6  0x0106bf00 : { KEEP(*(.bank_trampoline.6)) } >trampoline6
  .bank_trampoline7  0x0107bf00 : { KEEP(*(.bank_trampoline.7)) } >trampoline7
  .bank_trampoline8  0x0108bf00 : { KEEP(*(.bank_trampoline.8)) } >trampoline8
  .bank_trampoline9  0x0109bf00 : { KEEP(*(.bank_trampoline.9)) } >trampoline9
  .bank_trampoline10 0x010abf00 : { KEEP(*(.bank_trampoline.10)) } >trampoline10
  .bank_trampoline11 0x010bbf00 : { KEEP(*(.bank_trampoline.11)) } >trampoline11
  .bank_trampoline12 0x010cbf00 : { KEEP(*(.bank_trampoline.12)) } >trampoline12
  .bank_trampoline13 0x010dbf00 : { KEEP(*(.bank_trampoline.13)) } >trampoline13
  .bank_trampoline14 0x010ebf00 : { KEEP(*(.bank_trampoline.14)) } >trampoline14
  .bank_trampoline15 0x010fbf00 : { KEEP(*(.bank_trampoline.15)) } >trampoline15

  .vector 0x0100bffa : {
    SHORT(_start)
    BYTE(0x0)
    BYTE(0x04)
    SHORT(_cart_init)
  } >vector0
}

OUTPUT_FORMAT {
  FULL(bank0) FULL(trampoline0) FULL(vector0)
  FULL(bank1) FULL(trampoline1)
  FULL(bank2) FULL(trampoline2)
  FULL(bank3) FULL(trampoline3)
  FULL(bank4) FULL(trampoline4)
  FULL(bank5) FULL(trampoline5)
  FULL(bank6) FULL(trampoline6)
  FULL(bank7) FULL(trampoline7)
  FULL(bank8) FULL(trampoline8)
  FULL(bank9) FULL(trampoline9)
  FULL(bank10) FULL(trampoline10)
  FULL(bank11) FULL(trampoline11)
  FULL(bank12) FULL(trampoline12)
  FULL(bank13) FULL(trampoline13)
  FULL(bank14) FULL(trampoline14)
  FULL(bank15) FULL(trampoline15)
}
