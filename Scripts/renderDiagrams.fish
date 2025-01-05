#!/usr/bin/env fish

# Renders the documentation diagramms using d2
# Place ${assetName}-source.d2 file in the same directory as the expected output
# This script is not part of the build process, or github actions

for file in (find . -type f -name "*-source.d2")
    d2 $file \
        (string replace -r "\-source.d2" "@2x.png" $file) \
        --layout elk
    d2 $file \
        (string replace -r "\-source.d2" "~dark@2x.png" $file) \
        --layout elk \
        --theme 200
end
