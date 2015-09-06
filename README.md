![Typhoon](http://www.typhoonframework.org/typhoon-splash.png)
## <a href="http://typhoonframework.org">typhoonframework.org</a>  

Powerful dependency injection for Cocoa and CocoaTouch. Lightweight, yet full-featured and super-easy to use. 

## Not familiar with Dependency Injection? 

Visit <a href="http://typhoonframework.org">the Typhoon website</a> for an introduction. There's also a nice intro over at <a href="http://www.bignerdranch.com/blog/dependency-injection-ios/">Big Nerd Ranch</a>, or <a href="http://www.objc.io/issue-15/dependency-injection.html">here's an article</a>, by <a href="http://qualitycoding.org/">John Reid</a>. Quite a few books have been written on the topic, though we're not familiar with one that focuses specifically on Objective-C, Swift or Cocoa yet. 

## Is Typhoon the right DI framework for you? 

Check out the <a href="http://www.typhoonframework.org/#features">feature list</a>. 

---------------------------------------

# Usage

* Read the ***Quick Start*** for <a href="https://github.com/typhoon-framework/Typhoon/wiki/Quick-Start">Objective-C</a> or <a href="https://github.com/appsquickly/Typhoon/wiki/Swift-Quick-Start">Swift</a>. 
* Here's the <a href="https://github.com/typhoon-framework/Typhoon/wiki/Types-of-Injections">User Guide</a>.
* And here are the <a href="http://www.typhoonframework.org/docs/latest/api/modules.html">API Docs</a>. Generally googling a Typhoon class name will return the correct page as the first hit. 
* <a href="http://ios.caph.jp/typhoon/introduction">日本のドキュメンテーション</a>

```swift
let assembly = MyAssembly().activate()
let viewControler = assembly.recommendationController() as! RecommendationController
```

# Open Source Sample Applications

* Try the official <a href="https://github.com/typhoon-framework/Typhoon-Swift-Example">Swift Sample Application</a> or <a href="https://github.com/typhoon-framework/Typhoon-example">Objective-C Sample Application</a>. 
* This sample shows how to <a href="https://github.com/typhoon-framework/Typhoon-CoreData-RAC-Example">set up Typhoon with Storyboards, Core Data and Reactive Cocoa</a>. 

*Have a Typhoon example app that you'd like to share? Great! Get in touch with us :)*

# Installing 
<a href="https://github.com/appsquickly/Typhoon/wiki/Change-Log">![Cocoapods Version](https://cocoapod-badges.herokuapp.com/v/Typhoon/badge.png)</a> [![Pod Platform](http://img.shields.io/cocoapods/p/Typhoon.svg?style=flat)](http://typhoonframework.org/docs/latest/api/modules.html) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Dependency Status](https://www.versioneye.com/objective-c/typhoon/1.1.1/badge.svg?style=flat)](https://www.versioneye.com/objective-c/typhoon) [![Pod License](http://img.shields.io/cocoapods/l/Typhoon.svg?style=flat)](https://github.com/appsquickly/Typhoon/blob/master/LICENSE)

Typhoon is available through <a href="http://cocoapods.org/?q=Typhoon">CocoaPods</a> or <a href="https://github.com/Carthage/Carthage">Carthage</a>, and also builds easily from source.

##With CocoaPods . . . 

###Static Library

```ruby

# platform *must* be at least 5.0
platform :ios, '5.0'

target :MyAppTarget, :exclusive => true do

pod 'Typhoon'

end
```

###Dynamic Framework

If you're using Swift, you may wish to install dynamic frameworks, which can be done with the Podfile shown below: 

```ruby
# platform *must* be at least 8.0
platform :ios, '8.0'

# flag makes all dependencies build as frameworks
use_frameworks!

# framework dependencies
pod 'Typhoon'
```

Simply import the Typhoon module in any Swift file that uses the framework:

```Swift
import Typhoon
```

##With Carthage

```
github "appsquickly/Typhoon"
```

##From Source

Alternatively, add the source files to your project's target or set up an Xcode workspace. 

**NB:** *All versions of Typhoon work with iOS5 and up (and OSX 10.7 and up), iOS8 is only required if you wish to use dynamic frameworks.* 

---------------------------------------

# Feedback

### I'm not sure how to do [xyz]

If you can't find what you need in the Quick Start or User Guides above, then Typhoon users and contributors monitor the Typhoon tag on <a href="http://stackoverflow.com/questions/tagged/typhoon?sort=newest&pageSize=15">Stack Overflow</a>. Chances are your question can be answered there. 

### I've found a bug, or have a feature request

Please raise a <a href="https://github.com/typhoon-framework/Typhoon/issues">GitHub issue</a>.

### Interested in contributing?

 Great! Here's the <a href="https://github.com/typhoon-framework/Typhoon/wiki/Contribution-Guide">contribution guide.</a>

### I'm blown away!

Typhoon is a non-profit, community driven project. We only ask that if you've found it useful to star us on Github or send a tweet mentioning us (<a href="https://twitter.com/appsquickly">@appsquickly</a>). If you've written a Typhoon related blog or tutorial, or published a new Typhoon powered app, we'd certainly be happy to hear about that too. 

Typhoon is sponsored and lead by <a href="http://appsquick.ly">AppsQuick.ly</a> with <a href="https://github.com/appsquickly/Typhoon/graphs/contributors">contributions from around the world</a>. 
 
---------------------------------------
© 2012 - 2015 Jasper Blues, Aleksey Garbarev and contributors.



