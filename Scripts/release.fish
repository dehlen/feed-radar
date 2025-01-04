#!/usr/bin/env fish

set new_version $argv[1]
set archive_path FeedRadar.xcarchive

# Increment Build number
agvtool next-version

# Set marketing version 
# Using `sed` since `agvtool new-marketing-version` seems to be broken
sed -E \
    "s/MARKETING_VERSION = [0-9.]+;/MARKETING_VERSION = $new_version;/g" \
    FeedRadar.xcodeproj/project.pbxproj

# Update tag and push changes
git diff
read input \
    --prompt "echo \n(set_color magenta)Press space to continue!\n" \
    --silent \
    --nchars 1
if test $input != " "
    exit 1
end
# git add .
# git commit -m "release $new_version"
# git push
# git tag $new_version
# git push --tags


# # Build archive
# xcodebuild \
#     -project FeedRadar.xcodeproj \
#     -scheme FeedRadar \
#     -sdk iphoneos \
#     -configuration Release \
#     archive -archivePath archive_path |
#     xcbeautify

# # Upload to appstore connect
# xcodebuild \
#     -exportArchive \
#     -archivePath archive_path \
#     -exportOptionsPlist App/ExportOptions.plist \
#     -exportPath export
