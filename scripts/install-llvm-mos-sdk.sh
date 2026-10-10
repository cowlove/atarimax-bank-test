#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
sdk_prefix=${1:-"$HOME/opt/llvm-mos"}
release_url=https://github.com/llvm-mos/llvm-mos-sdk/releases/download/v23.3.0/llvm-mos-linux.tar.xz
archive_sha256=9f694497bc93a7c876d8c62325c7d74e7860346d80fbcd0555e19ba6856658c8

command -v curl >/dev/null || { printf 'curl is required.\n' >&2; exit 1; }
command -v sha256sum >/dev/null || { printf 'sha256sum is required.\n' >&2; exit 1; }
command -v tar >/dev/null || { printf 'tar is required.\n' >&2; exit 1; }

if [ -e "$sdk_prefix" ]; then
    if [ ! -x "$sdk_prefix/bin/mos-clang" ]; then
        printf 'SDK path exists but does not look like LLVM-MOS: %s\n' "$sdk_prefix" >&2
        exit 1
    fi
    printf 'Using existing LLVM-MOS SDK at %s\n' "$sdk_prefix"
else
    parent=$(dirname -- "$sdk_prefix")
    mkdir -p "$parent"
    temporary_dir=$(mktemp -d "$parent/.llvm-mos-sdk.XXXXXX")
    trap 'rm -rf "$temporary_dir"' EXIT HUP INT TERM
    archive="$temporary_dir/llvm-mos-linux.tar.xz"

    curl -fL --retry 2 "$release_url" -o "$archive"
    printf '%s  %s\n' "$archive_sha256" "$archive" | sha256sum -c -
    tar -xJf "$archive" -C "$temporary_dir"
    if [ ! -d "$temporary_dir/llvm-mos" ]; then
        printf 'Unexpected SDK archive layout.\n' >&2
        exit 1
    fi
    mv "$temporary_dir/llvm-mos" "$sdk_prefix"
    printf 'Installed stock LLVM-MOS SDK v23.3.0 at %s\n' "$sdk_prefix"
fi

"$project_dir/scripts/install-sdk-overlay.sh" "$sdk_prefix"
