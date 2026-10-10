#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
sdk_prefix=${1:-"$HOME/opt/llvm-mos"}
overlay="$project_dir/sdk-overlay"
platform=atari8-cart-atarimax128

if [ ! -x "$sdk_prefix/bin/mos-clang" ]; then
    printf 'LLVM-MOS SDK not found at %s\n' "$sdk_prefix" >&2
    exit 1
fi
if [ ! -f "$sdk_prefix/bin/mos-atari8-common.cfg" ]; then
    printf 'Expected stock Atari 8-bit config missing under %s/bin\n' "$sdk_prefix" >&2
    exit 1
fi

install -D -m 644 "$overlay/mos-atari8-cart-atarimax128.cfg" \
    "$sdk_prefix/bin/mos-atari8-cart-atarimax128.cfg"
install -D -m 644 "$overlay/mos-platform/$platform/include/banked-call.h" \
    "$sdk_prefix/mos-platform/$platform/include/banked-call.h"
install -D -m 644 "$overlay/mos-platform/$platform/lib/link.ld" \
    "$sdk_prefix/mos-platform/$platform/lib/link.ld"
install -D -m 644 "$overlay/mos-platform/$platform/lib/libcrt0.a" \
    "$sdk_prefix/mos-platform/$platform/lib/libcrt0.a"
install -d "$sdk_prefix/mos-platform/$platform/asminc"

for driver in clang clang++ clang-cpp; do
    ln -sfn "mos-$driver" "$sdk_prefix/bin/mos-$platform-$driver"
done

printf 'Installed AtariMax 128 SDK overlay into %s\n' "$sdk_prefix"
