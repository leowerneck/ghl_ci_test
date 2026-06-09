#!/usr/bin/env bash

MASTER_THORNLIST_URL=https://bitbucket.org/einsteintoolkit/manifest/raw/master/einsteintoolkit.th
MASTER_THORNFILE=einsteintoolkit.th
PRECOMPILE_THORNFILE=precompile.th

set -euo pipefail

if [ "$#" -gt 0 ]; then
    ET_DIRS=("$@")
else
    ET_DIRS=(et-gcc et-clang et-icc)
fi

rm -f "$MASTER_THORNFILE"
curl -LO "$MASTER_THORNLIST_URL"
if [ -f "$MASTER_THORNFILE" ]; then
    echo "Successfully downloaded master thornlist"
else
    echo "Could not download master thornlist"
    exit 1
fi

sed '/^GRHayL\//d; /^GRHayLET\//d' "$MASTER_THORNFILE" > "$PRECOMPILE_THORNFILE"
echo "Generated precompile thornlist"

echo "Downloading the Einstein Toolkit"
for etdir in "${ET_DIRS[@]}"; do
    rm -rf "$etdir"
    ./GetComponents --shallow --root "$etdir" "$PRECOMPILE_THORNFILE"
    rm -rf "$etdir/repos/GRHayL" "$etdir/repos/GRHayLET"
done
