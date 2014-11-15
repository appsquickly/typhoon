# Typhoon! (www.typhoonframework.org) 

Powerful dependency injection for Cocoa and CocoaTouch. Lightweight, yet full-featured and super-easy to use. 

## Not familiar with Dependency Injection? 

Visit <a href="http://typhoonframework.org">the Typhoon website</a> for an introduction. Otherwise. . . 

## Design Goals / Features

*Typhoon is a DI library that makes good use of the runtime's (ObjC or Swift) late binding nature in order to perform method interception and forwarding. This makes for a very compelling feature list.* 


* Non-invasive. ***No macros or XML required*** . . . Uses <a href="https://github.com/typhoon-framework/Typhoon/wiki/Quick-Start">powerful Objective-C runtime approach.</a>

* Its not necessary to change ***any*** of your classes to use the framework. ***Can be introduced into legacy applications.***

* No magic strings - ***supports IDE refactoring, code-completion and compile-time checking.*** 

* Provides ***full-modularization and encapsulation of configuration*** - grouping the application assembly 
details into a single document, with chapters. ***Let your architecture tell a story.*** 

* ***Dependencies declared in any order.*** (The order that makes sense to humans).

* Makes it easy to have multiple configurations of the same base-class or protocol. 

* Allows both dependency injection (injection of classes defined in the DI context) as well as configuration 
 management (values that get converted to the required type at runtime). Because this allows. . . 
 
* . . . ability to configure components for use in eg ___Test___ vs ___Production___ scenarios. This faciliates a 
good compromise between integration testing and pure unit testing. (Biggest testing bang-for-your-buck). 

* Supports ***injection of view controllers*** and ***storyboard integration.*** 

* Supports both ***initializer***, ***property*** and ***method injection***. For the latter two, it has customizable call-backs to ensure that the class is in the required state before and after injection. 

* Supports a mixture of static dependencies along with <a href="https://github.com/typhoon-framework/Typhoon/wiki/Types-of-Injections#injection-with-run-time-arguments">run-time arguments</a> to create factories on the fly. This greatly reduces the amount of boiler-plate code that you would normally write. 

* Excellent ***support for circular dependencies.***

* ***Powerful memory management features***. Provides pre-configured objects, without the memory overhead of singletons.

* ***Lightweight***. It has a very low footprint, so is appropriate for CPU and memory constrained devices. Weighs in at just 2500 lines of code in total! 

* ***Battle-tested*** - used in all kinds of Appstore-featured apps. 

# Installing

Typhoon is available through <a href="http://cocoapods.org/?q=Typhoon">CocoaPods</a> (recommended). Alternatively, add the source files to your project's target or set up an Xcode workspace. 

# Usage

* Read the <a href="https://github.com/typhoon-framework/Typhoon/wiki/Quick-Start">Quick Start</a> or <a href="https://github.com/typhoon-framework/Typhoon/wiki/Types-of-Injections">User Guide</a>.
* Try the <a href="https://github.com/typhoon-framework/Typhoon-Swift-Example">Swift Sample Application</a> or the <a href="https://github.com/typhoon-framework/Typhoon-example">Objective-C Sample Application</a>. 
* By popular demand, there's also an sample that features <a href="https://github.com/typhoon-framework/Typhoon-CoreData-RAC-Example">setting up Typhoon with Core Data and Reactive Cocoa</a>.
* Here are the <a href="http://www.typhoonframework.org/docs/latest/api/modules.html">API Docs</a>. Generally googling a Typhoon class name will return the correct page as the first hit. 



# Build Status 
![Build Status](http://www.typhoonframework.org/docs/latest/build-status/build-status.png?q=zz)


The following reports are published by our build server after each commit. Note that the status of the CI build is not related to tagged releases that are published and pushed to CocoaPods - these are stable. 

Test Failures typically indicate a bug that has been flagged, but not yet fixed. By policy we maintain more than 90% test coverage. 


* <a href="http://www.typhoonframework.org/docs/latest/api/modules.html">API</a>
* <a href="http://www.typhoonframework.org/docs/latest/test-results/index.html">Test Results</a>
* <a href="http://www.typhoonframework.org/docs/latest/coverage/index.html">Test Coverage</a>


# Feedback

Interested in contributing? <a href="https://github.com/typhoon-framework/Typhoon/wiki/Contribution-Guide">Contribution Guide.</a>

| I need help because | Action |
| :---------- | :------ | 
I'm not sure how to do [xyz]  | Typhoon users and contributors monitor the Typhoon tag on <a href="http://stackoverflow.com/questions/tagged/typhoon?sort=newest&pageSize=15">Stack Overflow</a>. Chances are your question can be answered there. 
Bugs and new feature requests | Please raise a <a href="https://github.com/typhoon-framework/Typhoon/issues">GitHub issue</a>.
I'll take all the help I can get | While Typhoon is free, open-source and volunteer based, if you're interested in professional consultation/support we do maintain a list of experts and companies that can provide services. Get in touch with us, and we'll do our best to connect you. 

**Typhoon is a free and community driven project. If you've enjoyed using it, we humbly ask you to let us know by starring us here on Github, sending a tweet mentioning us or emailing info@typhoonframework.org! And if you haven't enjoyed it, please let us know what you would like improved.**

# LICENSE

Apache License, Version 2.0, January 2004, http://www.apache.org/licenses/

© 2012 - 2014 Jasper Blues, Aleksey Garbarev and contributors.



