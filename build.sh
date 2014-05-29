#!/bin/sh

rm -fr build
rm -fr ~/Library/Developer/Xcode/DerivedData
xcodebuild -project Typhoon.xcodeproj/ -scheme 'Typhoon-OSXTests' test


rm -fr build
rm -fr ~/Library/Developer/Xcode/DerivedData
xcodebuild -project Typhoon.xcodeproj/ -scheme 'Typhoon-iOS' -configuration Debug -destination OS=7.1,name=iPad test


