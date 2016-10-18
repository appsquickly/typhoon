#Fail immediately if a task fails
set -e
set -o pipefail

xcodebuild clean test -project Typhoon.xcodeproj -scheme 'Typhoon-iOSTests' -configuration Debug \
-destination "platform=iOS Simulator,name=iPhone 5s,OS=latest" | xcpretty -c --report junit

xcodebuild -project Typhoon.xcodeproj/ -scheme 'Typhoon-OSXTests' clean test | xcpretty -c --report junit