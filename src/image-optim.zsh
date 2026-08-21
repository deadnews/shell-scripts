#!/usr/bin/env zsh
# Usage:
# ~/git/shell-scripts/src/image-optim.zsh --png-mod --png-level 7 --convert-webp $F

zparseopts -D -E -F -A opts -- -png-mod -png-level: -convert-webp
source $(which env_parallel.zsh)

main() {
    mime=$(file -b --mime-type "${1}")

    if [[ ${mime} == "image/png" ]]; then
        if [[ "${(k)opts[--png-mod]}" ]]; then
            optipng -strip all -o${opts[--png-level]:='5'} "${1}"
        else
            cjxl --quiet -d 0 "${1}" "${1:r}.jxl" && unlink "${1}"
        fi
    elif [[ ${mime} == "image/jpeg" ]]; then
        cjxl --quiet -d 0 --lossless_jpeg=1 "${1}" "${1:r}.jxl" && unlink "${1}"
    elif [[ ${mime} == "image/webp" ]]; then
        if [[ "${(k)opts[--convert-webp]}" ]] && rg -a -q 'VP8L' "${1}"; then
            dwebp "${1}" -o - | cjxl --quiet -d 0 - "${1:r}.jxl" && unlink "${1}"
        fi
    elif [[ ${mime} == "image/avif" ]]; then
        [[ ${1:e} == "avif" ]] || mv "${1}" "${1:r}.avif"
    fi
}

env_parallel --jobs 40% --eta main ::: "$@"

kdialog --title "image-optim" --passivepopup "${1:h:t} done" 7
