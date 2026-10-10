SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

MOS_CLANG ?= $(HOME)/opt/llvm-mos/bin/mos-atari8-cart-atarimax128-clang
CART ?= $(HOME)/opt/atari800-screen-dump/bin/cart
ATARI800 ?= $(HOME)/opt/atari800-screen-dump/bin/atari800
ATARI_CONFIG ?= $(HOME)/opt/atari800-screen-dump/etc/atarimax-emulator-test.cfg
RUN_ID := $(shell date +%Y%m%d-%H%M%S)

BUILD_DIR := build
ROM := $(BUILD_DIR)/atarimax-bank-test.rom
CAR_IMAGE := $(BUILD_DIR)/atarimax-bank-test.car
MAP := $(BUILD_DIR)/atarimax-bank-test.map
FAIL_ROM := $(BUILD_DIR)/atarimax-bank-test-force-fail.rom
FAIL_CAR := $(BUILD_DIR)/atarimax-bank-test-force-fail.car
FAIL_MAP := $(BUILD_DIR)/atarimax-bank-test-force-fail.map
EMU_OUTPUT := $(BUILD_DIR)/emulator-$(RUN_ID).txt
SCREEN_TEXT := $(BUILD_DIR)/screen-$(RUN_ID).txt
DUMP_SECONDS ?= 20
HOST_TIMEOUT ?= 30s
ATARI_FLAGS ?= -turbo
EXPECTED_RESULT ?= PASS
MIN_STATUS_MATCHES ?= 2

.PHONY: all rom package test test-fail clean

all: package

rom: $(ROM)

package: $(CAR_IMAGE)

$(BUILD_DIR):
	mkdir -p "$@"

$(ROM): minimal.c | $(BUILD_DIR)
	@test -x "$(MOS_CLANG)" || { echo "Missing compiler: $(MOS_CLANG)" >&2; exit 1; }
	"$(MOS_CLANG)" "$<" -Oz -o "$@" -Wl,-Map,"$(MAP)"

$(CAR_IMAGE): $(ROM)
	@test -x "$(CART)" || { echo "Missing Atari800 cart converter: $(CART)" >&2; exit 1; }
	"$(CART)" "$<" "$@" 41

$(FAIL_ROM): minimal.c | $(BUILD_DIR)
	@test -x "$(MOS_CLANG)" || { echo "Missing compiler: $(MOS_CLANG)" >&2; exit 1; }
	"$(MOS_CLANG)" -DTEST_FORCE_FAIL "$<" -o "$@" -Wl,-Map,"$(FAIL_MAP)"

$(FAIL_CAR): $(FAIL_ROM)
	@test -x "$(CART)" || { echo "Missing Atari800 cart converter: $(CART)" >&2; exit 1; }
	"$(CART)" "$<" "$@" 41

test-fail: CAR_IMAGE := $(FAIL_CAR)
test-fail: EXPECTED_RESULT := FAIL
test-fail: $(FAIL_CAR) test

test: package
	@test -x "$(ATARI800)" || { echo "Missing patched Atari800: $(ATARI800)" >&2; exit 1; }
	@command -v timeout >/dev/null || { echo "GNU timeout is required." >&2; exit 1; }
	@set -eu; \
	echo "Running Atari800 headlessly for $(DUMP_SECONDS) emulated seconds (host timeout $(HOST_TIMEOUT))..."; \
	SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy timeout "$(HOST_TIMEOUT)" "$(ATARI800)" \
	  -config "$(ATARI_CONFIG)" -no-autosave-config -xl \
	  -cart "$(abspath $(CAR_IMAGE))" -cart-type 41 $(ATARI_FLAGS) \
	  -dump-screen-after "$(DUMP_SECONDS)" > "$(EMU_OUTPUT)" 2>&1; \
	awk '/^Graphics 0 screen at / { capture = 1; next } capture && rows < 24 { print; rows++ }' "$(EMU_OUTPUT)" > "$(SCREEN_TEXT)"; \
	[ "$$(wc -l < "$(SCREEN_TEXT)")" -eq 24 ] || { echo 'Atari800 did not produce a complete 24-row screen dump:' >&2; cat "$(EMU_OUTPUT)" >&2; exit 1; }; \
	echo 'Atari screen dump:'; cat "$(SCREEN_TEXT)"; \
	fail_matches=$$(grep -Eio 'FAIL' "$(SCREEN_TEXT)" | awk 'END { print NR + 0 }' || true); \
	pass_matches=$$(grep -Eio 'PASS' "$(SCREEN_TEXT)" | awk 'END { print NR + 0 }' || true); \
	if [ "$(EXPECTED_RESULT)" = FAIL ]; then \
	  if [ "$$fail_matches" -ge "$(MIN_STATUS_MATCHES)" ]; then echo "Forced-failure harness check: PASS ($$fail_matches FAIL tokens)."; else echo "Forced-failure harness check: FAIL (only $$fail_matches FAIL tokens; need $(MIN_STATUS_MATCHES))." >&2; exit 1; fi; \
	elif [ "$$fail_matches" -gt 0 ]; then echo "AtariMax bank test: FAIL ($$fail_matches FAIL tokens)." >&2; exit 1; \
	elif [ "$$pass_matches" -ge "$(MIN_STATUS_MATCHES)" ]; then echo "AtariMax bank test: PASS ($$pass_matches PASS tokens, no FAIL)."; \
	else echo "Could not verify result: $$pass_matches PASS and $$fail_matches FAIL tokens; need $(MIN_STATUS_MATCHES) PASS tokens." >&2; exit 1; fi

clean:
	rm -f "$(ROM)" "$(ROM).elf" "$(CAR_IMAGE)" "$(MAP)" "$(FAIL_ROM)" "$(FAIL_ROM).elf" "$(FAIL_CAR)" "$(FAIL_MAP)" "$(BUILD_DIR)"/emulator-*.txt "$(BUILD_DIR)"/screen-*.txt
