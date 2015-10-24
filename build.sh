#!/bin/bash

echo '----------------------------------------------------------------------------------------------------'
echo "This build script  requires the following dependencies to be installed:"
echo '----------------------------------------------------------------------------------------------------'
echo "gem install xcpretty"
echo "sudo port install lcov"
echo "sudo port install groovy"
echo "sudo port install doxygen"
echo "sudo port install graphviz"
echo '----------------------------------------------------------------------------------------------------'

#Configuration
reportsDir=build/reports
sourceDir=Source
resourceDir=Resources



requiredCoverage=87

#Fail immediately if a task fails
set -e
set -o pipefail


#Clean
rm -fr ~/Library/Developer/Xcode/DerivedData/*
rm -fr ./build

#Init submodules
git submodule init
git submodule update

#Stamp build Initially failing
ditto ${resourceDir}/build-failed.png ${reportsDir}/build-status/build-status.png


xcodebuild -project Typhoon.xcodeproj/ -scheme 'Typhoon' clean build | xcpretty -c

#Run tests and produce coverage report for iOS Simulator
osVersion=9.1
platform=iOS_Simulator_$osVersion
mkdir -p ${reportsDir}/${platform}
xcodebuild clean test -project Typhoon.xcodeproj -scheme 'Typhoon-iOSTests' -configuration Debug \
-destination "platform=iOS Simulator,name=iPhone 5s,OS=$osVersion" | xcpretty -c --report junit
mv ${reportsDir}/junit.xml ${reportsDir}/${platform}/junit.xml

groovy http://frankencover.it/with --source-dir Source --output-dir ${reportsDir}/$platform -r${requiredCoverage}
echo '----------------------------------------------------------------------------------------------------'

#Run tests and produce coverage report for iOS Simulator
osVersion=8.4
platform=iOS_Simulator_$osVersion
mkdir -p ${reportsDir}/${platform}
xcodebuild clean test -project Typhoon.xcodeproj -scheme 'Typhoon-iOSTests' -configuration Debug \
-destination "platform=iOS Simulator,name=iPhone 5s,OS=$osVersion" | xcpretty -c --report junit
mv ${reportsDir}/junit.xml ${reportsDir}/${platform}/junit.xml

groovy http://frankencover.it/with --source-dir Source --output-dir ${reportsDir}/$platform -r${requiredCoverage}
echo '----------------------------------------------------------------------------------------------------'


#Compile, run tests and produce coverage report for OSX
platform=OSX
mkdir -p ${reportsDir}/${platform}


xcodebuild -project Typhoon.xcodeproj/ -scheme 'Typhoon-OSXTests' clean test | xcpretty -c --report junit
mv ${reportsDir}/junit.xml ${reportsDir}/${platform}/junit.xml

groovy http://frankencover.it/with --source-dir Source --output-dir ${reportsDir}/OSX -r${requiredCoverage}
echo '--------------------------------------------------------------------------------'
echo '   💉  Typhoon is ready to inject.'
echo '--------------------------------------------------------------------------------'


#Stamp build passing
ditto ${resourceDir}/build-passed.png ${reportsDir}/build-status/build-status.png
