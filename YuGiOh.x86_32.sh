#!/bin/sh
echo -ne '\033c\033]0;YuGiOh\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/YuGiOh.x86_32.arm32" "$@"
