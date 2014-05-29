#!/bin/sh
rm -fr build
rm -fr ~/Library/Developer/Xcode/DerivedData
xcodebuild -project Typhoon.xcodeproj/ -scheme 'iOS Tests' -configuration Debug -destination OS=7.1,name=iPad test

rm -fr build
rm -fr ~/Library/Developer/Xcode/DerivedData
xcodebuild -project Typhoon.xcodeproj/ -scheme 'Typhoon-OSXTests' test

