#!/usr/bin/env fish

# Renders the documentation diagramms using d2
# Place ${assetName}-source.d2 file in the same directory as the expected output
# This script is not part of the build process, or github actions

for file in (find . -type f -name "*-source.d2")
    set base (string trim (string replace -r '-source.d2' '' $file))
    d2 $file "$base@2x.png" --layout elk
    d2 $file "$base~dark@2x.png" --layout elk --theme 200
end
