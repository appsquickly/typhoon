# Description

A Spring-like dependency injection container for Objective-C.

### What is Dependency Injection? 

"In conventional software development, the dependent object decides for itself what concrete classes it will use. 
In the dependency injection pattern, this decision is delegated to the "injector" which can choose to substitute 
different concrete class implementations of a dependency contract interface at run-time rather than at compile time.

Being able to make this decision at run-time rather than compile time is the key advantage of dependency injection. 
Multiple, different implementations of a single software component can be created at run-time and passed (injected) 
into the same test code. The test code can then test each different software component without being aware that what 
has been injected is implemented differently." -- Wikipedia

### Why Spring for Objective-C?

Spring is a very popular dependency injection container for Java and .NET. 

There have been a couple of dependency injection containers that follow in the footsteps of Google Guice. The authors
have done a great job, but personally I prefer a spring-style (especially with XML) approach for the following 
reasons:

* Allows both dependency injection (classes defined in the DI context) as well as configuration management (values 
* that get converted to the required type at runtime).
* Application assembly - the wiring of dependencies and configuration management - is all encapsulated in a convenient document. 
* Encourages polymorphism and makes it easy to have multiple implementations of a base-class or protocol. For example
 you can have a tunes-store client, and inject either a master-card payment engine or a visa payment engine.
* Supports dependency injection by type (definitions satisfying a class or protocol) as well as by reference. 
* Also supports "annotation" and code style injection. 

###Isn't Objective-C a dynamic language? 

Yes, and I love categories, method swizzling, duck-typing and all that cool stuff. None of these are replacements for 
DI though. DI is just a design pattern and you can do it without a container. Having one is handy though. 


# Usage

### Defining Components


```xml
<?xml version='1.0' encoding='UTF-8'?>
<assembly>

    <component class="Knight" id="knight">
        <property name="quest" ref="quest"/>
        <property name="damselsRescued" value="12"/>
    </component>

    <component class="CampaignQuest" id="quest" scope="prototype"/>
    
    <component class="CavalryMan" id="anotherKnight">
        <initializer selector="initWithQuest:">
            <argument parameterName="quest" ref="quest"/>
        </initializer>
    </component>

    <!-- This is just an example of a factory-method class. In fact, you could just inject an NSURL instance directly by 
    value. . . more examples and better docs to follow in the coming days. -->
    <component class="NSURL" id="serviceUrl">
        <factory-method selector="URLWithString:">
            <argument parameterName="string" value="http://dev.foobar.com/service/"/>
        </factory-method>
    </component>

</assembly>
```

### Using Assembled Components 

```objective-c
SpringComponentFactory componentFactory = [[SpringXmlComponentFactory alloc] 
    initWithConfigFileName:@"MiddleAgesAssembly.xml"];
Knight* knight = [_componentFactory objectForKey:@"knight"];
id<Quest> quest = knight.quest;
```

# Docs

More to follow over the coming days. Meanwhile, the Tests folder contains further usage examples.

* <a href="https://github.com/jasperblues/spring-objective-c/wiki">Wiki</a>
* <a href="http://jasperblues.github.com/spring-objective-c/api/index.html">API</a>
* <a href="http://jasperblues.github.com/spring-objective-c/coverage/index.html">Coverage Reports</a>

# Building 

## Just the Framework

Open the project in XCode and choose Product/Build. 

## Command-line Build

Includes Unit Tests, Integration Tests, Code Coverge and API reports installed to Xcode. 

### Requirements (one time only)

In addition to Xcode, requires the Appledoc and lcov packages. A nice way to install these is with <a href="http://www.macports.org/install.php">MacPorts</a>.

```sh
git clone https://github.com/tomaz/appledoc.git
sudo install-appledoc.sh
sudo port install lcov
```

NB: Xcode 4.3+ requires command-line tools to be installed separately. 

### Running the build (every other time)

```sh
ant 
```
# Feature Requests and Contributions

. . . are very welcome. 

If you're using the API shoot me an email and tell me what you're doing with it. 

# Compatibility 

* Spring-Objective-C can be used with OSX and iOS. It has not been tested with GnuStep. It was built with ARC, but
should also work with garbage collection and 32 bit environments (more on this in the coming days). 

# Who's using it? 

* Just me so far. I had a family beach holiday booked over the Christmas/New Year period of 2012, but there was a late typhoon passing over
 the Philippines, so I rolled-up my sleeves and wrote the DI container that I'd been meaning to get around to. It's basically feature-complete for
 version 1.0, and over the coming days I'll be writing more tests and documentation.
 
 If you're using it, please shoot me an email and let me know.
 
# Authors

* <a href="http://ph.linkedin.com/pub/jasper-blues/8/163/778">Jasper Blues</a> - <a href="mailto:jasper@appsquick.ly?Subject=spring-objective-c">jasper@appsquick.ly</a>
         
### With contributions from: 

* Your name here!!!!!!


# LICENSE

Apache License, Version 2.0, January 2004, http://www.apache.org/licenses/

* © 2012 jasper blues


