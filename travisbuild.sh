#Fail immediately if a task fails
#set -e
#set -o pipefail

fastlane scan Typhoon.xcodeproj --scheme Typhoon-iOSTests

#xcodebuild test -project Typhoon.xcodeproj -scheme 'Typhoon-iOSTests' -configuration Debug \
#-destination "platform=iOS Simulator,name=iPhone 6,OS=latest" ONLY_ACTIVE_ARCH=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=""

#xcodebuild -project Typhoon.xcodeproj/ -scheme 'Typhoon-OSXTests' clean test | xcpretty -c --report junit
