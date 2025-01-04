#!/usr/bin/env fish

# Uploads app archive to appstore connect and pushes the tag to the remote
# Expects single argument with the new version

set new_version $argv[1]

function space_to_continue
    read input \
        --prompt "echo \n(set_color magenta)Press space to continue!\n" \
        --silent \
        --nchars 1
    if test $input != " "
        exit 1
    end
end

function update_version
    # Increment Build number
    agvtool next-version
    # Set marketing version 
    # Using `sed` since `agvtool new-marketing-version` seems to be broken
    sed -E -i "" \
        "s/MARKETING_VERSION = [0-9.]+;/MARKETING_VERSION = $new_version;/g" \
        FeedRadar.xcodeproj/project.pbxproj
end

function tag_and_push_changes
    git diff
    space_to_continue
    git add .
    git commit -m "release $new_version"
    git push
    git tag $new_version
    git push --tags
end

function archive_and_upload
    set archive_path FeedRadar.xcarchive
    # Build archive
    xcodebuild \
        -project FeedRadar.xcodeproj \
        -scheme FeedRadar \
        -sdk iphoneos \
        -configuration Release \
        archive -archivePath $archive_path |
        xcbeautify
    # Upload to appstore connect
    xcodebuild \
        -exportArchive \
        -archivePath $archive_path \
        -exportOptionsPlist App/ExportOptions.plist \
        -exportPath export
    # Cleanup
    rm -r archive_path
end

function open_appstore_connect
    echo (set_color magenta) "TestFlight -> Crypto compliance"
    echo (set_color magenta) "Extrnal Testers -> Add latest build"
    space_to_continue
    open https://appstoreconnect.apple.com/apps
end

update_version
tag_and_push_changes
archive_and_upload
open_appstore_connect
