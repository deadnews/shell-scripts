#!/usr/bin/env zsh
set -euo pipefail

name='[name]'

for F in "$@"; do
    echo ${F:t}
    mkdir -p "${F:h}/out"
    mksfile="${F:h}/ENG Subs/${F:t:r}.eng.${name}.mks"
    outfile="${F:h}/out/${F:t}"

    mkvmerge --output ${outfile} --compression 0:zlib ${mksfile} ${F}
done

# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
