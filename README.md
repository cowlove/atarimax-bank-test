# AtariMax bank-switch test

This project builds the bank-counter probe as a raw 128 KiB ROM and packages it as an Atari Type 41 `.car`.

From jiml4:

```sh
cd ~/build/atarimax-bank-test
make test
```

`make test` launches the patched Atari800 build headlessly with SDL's dummy video/audio drivers. After `DUMP_SECONDS` emulated PAL/NTSC seconds (10 by default), Atari800 writes its 24×40 Graphics 0 screen at `SAVMSC` to stdout as ASCII and exits. Make extracts those screen rows and checks for status tokens directly—no X11 focus, screenshots, or OCR are involved. The host-side `timeout` is a failsafe in case the emulated-time dump never triggers.

The current ROM reports roughly every two emulated seconds, so the default ten-second run captures several reports. Use `make test DUMP_SECONDS=12` to run longer, `make test ATARI_FLAGS=-turbo` to exercise turbo mode, or `make test HOST_TIMEOUT=45s` to extend the real-time failsafe.

`make test-fail` builds a separate ROM that deliberately reports `FAIL`; the harness considers that target successful only when it detects at least two `FAIL` tokens. This checks the harness's negative path without changing the normal ROM.

Build tools default to Jim's local installs. Override `MOS_CLANG`, `SDK_CONFIG`, `CART`, `ATARI800`, or `ATARI_CONFIG` on the make command line if their locations differ. The emulator defaults to `~/opt/atari800-screen-dump/bin/atari800`. `make clean` removes generated ROM/CAR/map files and headless output logs in `build/`.
