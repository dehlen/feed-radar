#!/usr/bin/env fish
cd Core
swift package --disable-sandbox preview-documentation \
    --target Core \
    --symbol-graph-minimum-access-level internal
