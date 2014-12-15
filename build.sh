#!/bin/bash

#Configuration
baseDir=.
reportsDir=${baseDir}/build/reports
sourceDir=${baseDir}/Source
resourceDir=${baseDir}/Scripts

requiredCoverage=86

#Fail immediately if a task fails
set -e
set -o pipefail


#Clean
rm -fr ~/Library/Developer/Xcode/DerivedData
rm -fr ./build

#Init submodules
git submodule init
git submodule update

#Stamp build Initially failing
ditto ${resourceDir}/build-failed.png ${reportsDir}/build-status/build-status.png


#Compile, run tests and produce coverage report for iOS Simulator

rm -fr ~/Library/Developer/Xcode/DerivedData
xcodebuild test -project Typhoon.xcodeproj -scheme 'Typhoon-iOSTests' -configuration Debug \
-destination 'platform=iOS Simulator,name=iPhone 5s,OS=8.1' | xcpretty -c --report junit
ditto ${reportsDir}/junit.xml ${reportsDir}/iOS_Simulator/junit.xml

groovy http://frankencover.it/with --source-dir Source --output-dir ${reportsDir}/iOS_Simulator -r${requiredCoverage}
echo '----------------------------------------------------------------------------------------------------'


#Compile, run tests and produce coverage report for OSX

rm -fr ~/Library/Developer/Xcode/DerivedData
xcodebuild -project Typhoon.xcodeproj/ -scheme 'Typhoon-OSXTests' test | xcpretty -c --report junit
ditto ${reportsDir}/junit.xml ${reportsDir}/OSX/junit.xml

groovy http://frankencover.it/with --source-dir Source --output-dir ${reportsDir}/OSX -r${requiredCoverage}
echo '--------------------------------------------------------------------------------'



#Produce API Documentation
echo "Generating Doxygen documentation"
doxygen > ${reportsDir}/doxygen_out.txt 2>&1
ditto ${resourceDir}/navtree.css ${reportsDir}/api
ditto ${resourceDir}/doxygen.png ${reportsDir}/api

#Stamp build Initially passing
ditto ${resourceDir}/build-passed.png ${reportsDir}/build-status/build-status.png
