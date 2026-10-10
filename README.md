# AtariMax bank-switch test

This project builds the bank-counter probe as a raw 128 KiB ROM and packages it as an Atari Type 41 `.car`.

Run locally:

```sh
cd ~/src/atarimax-bank-test
make test
```

`make test` launches the patched Atari800 build headlessly with SDL's dummy video/audio drivers. After `DUMP_SECONDS` emulated PAL/NTSC seconds (10 by default), Atari800 writes its 24×40 Graphics 0 screen at `SAVMSC` to stdout as ASCII and exits. Make extracts those screen rows and checks for status tokens directly—no X11 focus, screenshots, or OCR are involved. The host-side `timeout` is a failsafe in case the emulated-time dump never triggers.

The current ROM reports roughly every two emulated seconds, so the default ten-second run captures several reports. Use `make test DUMP_SECONDS=12` to run longer, `make test ATARI_FLAGS=-turbo` to exercise turbo mode, or `make test HOST_TIMEOUT=45s` to extend the real-time failsafe.

`make test-fail` builds a separate ROM that deliberately reports `FAIL`; the harness considers that target successful only when it detects at least two `FAIL` tokens. This checks the harness's negative path without changing the normal ROM.

The compiler defaults to the official LLVM-MOS SDK v23.3.0 distribution under `~/opt/llvm-mos`. The AtariMax 128 platform is project-specific and is installed as a small overlay with `./scripts/install-sdk-overlay.sh`; it does not replace stock SDK files. The installer adds the `mos-atari8-cart-atarimax128.cfg` config and `mos-atari8-cart-atarimax128-clang` (plus `clang++` and `clang-cpp`) symlinks, following the stock SDK's target naming convention. You can compile directly with `~/opt/llvm-mos/bin/mos-atari8-cart-atarimax128-clang`. `~/opt/atari800-screen-dump` contains the locally built patched emulator and `cart` utility. Override `MOS_CLANG`, `CART`, `ATARI800`, or `ATARI_CONFIG` on the make command line if their locations differ. `make clean` removes generated ROM/CAR/map files and headless output logs in the project's `build/` directory.

To recreate the toolchain on another Linux host, run `./scripts/install-llvm-mos-sdk.sh`. It downloads the official Linux SDK v23.3.0, verifies its SHA-256, installs it under `~/opt/llvm-mos`, and applies the AtariMax overlay. The SDK archive is distributed by the [official LLVM-MOS SDK v23.3.0 release](https://github.com/llvm-mos/llvm-mos-sdk/releases/tag/v23.3.0); its expected SHA-256 is `9f694497bc93a7c876d8c62325c7d74e7860346d80fbcd0555e19ba6856658c8`.
