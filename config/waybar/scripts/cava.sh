#!/usr/bin/env bash

bar="▁▂▃▄▅▆▇█"
dict='s/;//g;'

i=0
while [ "$i" -lt "${#bar}" ]; do
    dict+="s/$i/${bar:i:1}/g;"
    i=$((i + 1))
done

# write temp cava config
config_file="/tmp/polybar_cava_config"
cat > "$config_file" <<'EOF'
[general]
bars = 20

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# read stdout from cava
cava -p "$config_file" | while IFS= read -r line; do
    # Hide when all values are 0 (no movement)
    if [ -n "${line//[0;]/}" ]; then
        printf '%s\n' "$line" | sed "$dict"
    else
        printf '\n'
    fi
done