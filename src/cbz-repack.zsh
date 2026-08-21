#!/usr/bin/env zsh
set -euo pipefail

# Usage:
# fd -e cbz --changed-before 2d --exec-batch ~/git/shell-scripts/src/cbz-repack.zsh

for F in "$@"; do
    mime=$(file -b --mime-type "${F}")

    if [[ ${mime} == "application/zip" ]]; then
        tmp=$(mktemp -d)

        if ! unzip -jqo "${F}" -d ${tmp}; then
            echo unzip failed for "${F}"
        elif fd --has-results . ${tmp} -e jpg -e jpeg -e png; then
            echo "$(du -sh "${F}") →"

            fd . ${tmp} -e jpg -e jpeg -e png \
                -j 8 -x cjxl --quiet -d 0 --lossless_jpeg=1 {} {.}.jxl \
                || echo cjxl failed for some pages of "${F}"
            fd . ${tmp} -e jxl -x rm -f {.}.jpg {.}.jpeg {.}.png
            bsdtar --format=zip -cf "${F:r}.cbz" -C ${tmp} .

            echo "$(du -sh "${F}")\n"
        fi
        rm -rf ${tmp}
    fi
done

kdialog --title "cbz-repack" --passivepopup "${1:h:t} done" 7
