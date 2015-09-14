A super-lightweight logging framework for Objective-C projects. Based on Brenwill workshop's Flexible iOS Logging Framework: http://brenwill.com/2010/flexible-ios-logging/ 

#FEATURES

* Just one file - use as an alternative to NSLog
* Supports multiple log levels - Debug, Info, Warning, Error, Trace
* Performance: Logging can be compiled in our out of code with one flag. 
* Supports multiple formats - line numbers, file, etc. 

#INSTALLING

Just include `OCLogTemplate.h` in your project. 

Can be installed via CocoaPods too, for use as a transitive dependency in libraries, etc. 

```ruby
pod 'OCLogTemplate'
```

#USAGE

```objc
LogDebug(@"Message: %@", formatArg);
```

#FULLY FLEDGED LOGGING TOOLS

* <a href="https://github.com/CocoaLumberjack/CocoaLumberjack">CoocaLumberjack</a>
* <a href="https://github.com/fpillet/NSLogger">NSLogger</a>

But no doubt you've heard of those ;) 









