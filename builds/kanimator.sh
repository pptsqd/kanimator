#!/bin/sh
echo -ne '\033c\033]0;kanimator\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/kanimator.x86_64" "$@"
