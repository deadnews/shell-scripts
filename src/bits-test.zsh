#!/usr/bin/env zsh
source $(which env_parallel.zsh)

bits-test() {
    bit_depth=$(mediainfo --Inform="Audio;%BitDepth%" ${1})
    sample_rate=$(mediainfo --Inform="Audio;%SamplingRate%" ${1})

    if [[ ${bit_depth} == "24" ]]; then
        echo "${bit_depth}/${sample_rate}: ${1}"
    fi
}

for H in "$@"; do
    find "${H}" -type f -iname '*.flac' | env_parallel --jobs 50% bits-test {}
done
