#!/bin/sh
xcodebuild -project Typhoon.xcodeproj/ -scheme 'iOS Tests' -configuration Debug -destination OS=7.1,name=iPad test
xcodebuild -project Typhoon.xcodeproj/ -scheme 'Typhoon-OSXTests' test

