#!/usr/bin/env zsh
set -euo pipefail

# Usage:
# fd -e cbz --exec-batch ~/git/shell-scripts/src/cbz-repack.zsh

for F in "$@"; do
    mime=$(file -b --mime-type "${F}")

    if [[ ${mime} == "application/zip" ]]; then
        size=$(du -sh "${F}" | cut -f1)
        tmp=$(mktemp -d)

        if unzip -jqo "${F}" -d ${tmp}; then
            fd . ${tmp} -e jpg -e jpeg -x cjxl -d 0 --lossless_jpeg=1 {} {.}.jxl
            fd . ${tmp} -e jpg -e jpeg -x rm -f
            fd . ${tmp} -e png -x cjxl -d 0 {} {.}.jxl
            fd . ${tmp} -e png -x rm -f
            # fd . ${tmp} -e webp -x cwebp -quiet -m 6 -pass 5 -q 99 {} -o {.}.webp
            bsdtar --format=zip -cf "${F:r}.cbz" -C ${tmp} .
            echo ${size} → $(du -sh "${F}")
        else
            echo unzip failed for "${F}"
        fi

        rm -rf ${tmp}
    fi
done

kdialog --title "cbz-repack" --passivepopup "${1:h:t} done" 7
