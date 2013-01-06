# Description

A Spring-like dependency injection container for Objective-C.

### What is Dependency Injection? 

Many people have trouble getting the hang of dependency injection, at first. And I think part of the problem is that
it is actually so simple that we're inclined to look for something more complicated. "Surely that there has to be
more to it?!", so to say.  

So, with that in mind, imagine that you're writing an app that gives weather reports. You need a cloud-service ('scuse the pun ;) ) to provide the data, and at first you go for a free weather report provider, but in future you'd like to integrate a weather service with better accuracy and more features. So, like a good object-oriented developer, you make a WeatherClient protocol and back it initially with an implementation based on the free provider. 

___Without dependency injection, you might have a View Controller thus___: 

```objective-c

-(id) init 
{
 self = [super init];
 if (self) 
 {
 //The class using some collaborating class makes the collaborator
 //it might be one of several classes using the weatherClient. 
  _weatherClient = [GoogleWeatherClientImpl alloc] initWithParameters:xyz];
 }
 return self;
}

```
The thing with this approach is, if you wanted to change to another weather client implementation you'd have to go
and find all the places in your code that use the old one, and move them over to the new one. Each time, making sure to pass in the correct initialization parameters. 

Also, in order to test your view controller, you now have to test the weather client at the same time, and this 
can get tricky, especially as your application gets more complex. Imagine testing Class A, depends on Class B, depends on Class C, depends on .... Not much fun!

So with dependency injection, rather than having objects make their own collaborators we have them supplied to the class instance via an initializer or property setter. 

_WTF? Is that all they mean by 'injected'?_. Yes it is. And because of this, the GoogleWeatherClientImpl is now 
declared in a single place, and all of the classes that need to use some kind of id&lt;WeatherClient&gt; have it 
passed in. This means that: 

* If you want to change from one implementation to another, you need only change a single declaration. 
* Classes are easier to test, because we can supply simple mocks and stubs in place of concrete collaborators. Or the real collaborators, but configured to be used in a test scenario.
* It promotes separation of concerns and a clear contract between classes. 
* Your app is easier to maintain and can accommodate new requirements. 


### Why Spring for Objective-C?

Spring is a very popular dependency injection container that is available for Java and .NET, as well as ActionScript.  

In Objective-C land, there have been a couple of dependency injection containers that follow in the footsteps of 
Google Guice. The authors have done a great job (objection is especially good), but personally I prefer a 
spring-style approach for the following reasons:

* Allows both dependency injection (injection of classes defined in the DI context) as well as configuration 
 management (values that get converted to the required type at runtime).
* Application assembly - the wiring of dependencies and configuration management - is all encapsulated in a 
convenient document. This modularization is a good thing. Now you know where to look if you need to change something. 
* Encourages polymorphism and makes it easy to have multiple implementations of the same base-class or protocol. 
 For example, let's say you have a music store application that depends on a payment engine. Spring-style makes it
easy to define both a master-card payment engine or a visa payment engine.
* Supports dependency injection by type (definitions satisfying a class or protocol) as well as by reference. 
* Also supports "annotation" (aka Macro) and code/DSL style injection.

###Isn't Objective-C a dynamic language? 

Yes, and I love categories, method swizzling, duck-typing, class clusters, accociative references in categories, and 
all that cool stuff. None of these are replacements for DI. DI is just a design pattern, and the thing about design
patterns is that they're often relevant in more than one language. 

Besides, people said that <a href="http://stackoverflow.com/questions/309711/dependency-injection-framework-for-cocoa">
you don't need Dependency Injection in Objective-C</a> three years ago. Now there are around 15 different dependency 
injection containers. So the question becomes which approach do you like best? 

### Why XML? 

I'm not saying XML is the ultimate destination. ___But I think it's already an improvement if you want:___

* Dependencies declared in any order. (The order that makes sense).  
* Non-invasive.
* Modularization of application assembly details.  
* Ability to configure components for use in eg test vs production scenarios. 
* Both initializer and property injection. 

Stay tuned for more DI styles in the coming weeks. Including a GUI tool that I'll think you'll really like! 


# Usage

##New! Check out the example at: https://github.com/jasperblues/spring-objective-c-example

### Defining Components


```xml
<assembly xmlns="http://jasperblues.github.com/spring-objective-c/schema/assembly"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://jasperblues.github.com/spring-objective-c/schema/assembly
          http://www.appsquick.ly/schema/assembly.xsd">

    <description>
        This is the application assembly. The schema declaration above gives code-completion in supported IDEs
        (works in AppCode, but the Xcode XML editor doesn't resolve schemas, it seems).
        Dependencies can be resolved by reference (ie a name), by matching the required type or protocol or by value.
        Dependencies can be declared in any order - Spring Objective-C will work out how to resolve them.
    </description>

    <component class="Knight" key="knight">
        <property name="quest" ref="quest">
            <description>
                Properties can be injected by reference.
            </description>
        </property>
        <property name="damselsRescued" value="12">
            <description>
                Property arguments can also be injected by value. The container will look up the required
                class or primitive type. It's easy to register your own additional converters.
            </description>
        </property>
    </component>


    <component class="CampaignQuest" key="quest" scope="prototype" after-property-injection="questAfterPropertyInjection">
        <description>
            Knight has a dependency on any class conforming to the Quest protocol. In this case it's a
            [CampaignQuest class].

            Note the 'after-property-injection' attribute. This is a custom method that can be called after all
            properties have been injected.
        </description>

        <property name="imageUrl" value="http://www.appsquick.ly/theQuest.jpg">
            <description>
                This is a property of type NSURL. The container will convert the supplied string value
                and inject it for us.

                Besides the primitive types (int, BOOL, etc), a handful of useful object conversion types
                are included. You can also easily register your own additional converters.
            </description>
        </property>
    </component>

    <component class="CavalryMan" key="anotherKnight">
        <description>
            This time, we're using initializer injection. As shown below, you can also mix initializer
            injection with property injection.
        </description>
        <initializer selector="initWithQuest:">
            <argument parameterName="quest" ref="quest"/>
        </initializer>
        <property name="hasHorseWillTravel" value="yes">
            <description>
                This is a primitive property of type BOOL.
            </description>
        </property>
    </component>


    <component class="NSURL" key="serviceUrl">
        <description>
            This is an example of a component instantiated from a class method. (In fact, you could inject
            an NSURL instance directly by value, but anyway. . . ).

            Note the "is-class-method" attribute: Spring Objective-C will normally guess this, so if the method
            follows objective-c naming conventions, this wouldn't be needed. That is to say, if the method name
            starts with "init" it will be treated as an instance method, otherwise it will be resolved as a
            class method. . . supplying this attribute will override Spring Objective-C's guess.
        </description>
        <initializer selector="URLWithString:" is-class-method="yes">
            <description>
                Unlike property injection, initializer arguments require type to be set explicitly, unless the
                type is a primitive - BOOL, int, etc. . . (This is because the Objective-C runtime doesn't
                include detailed type information for selectors - only whether the type is an object or
                primitive type. (The container will remind you to set this attribute if you forget).
            </description>
            <argument parameterName="string" value="http://dev.foobar.com/service/" required-class="NSString"/>
        </initializer>
    </component>

    <component class="SwordFactory" key="swordFactory">
        <description>
            This is a factory component.
        </description>
    </component>

    <component class="Sword" key="blueSword" factory-component="swordFactory">
        <description>
            This is a component that has been manufactured from a factory component.
        </description>
        <initializer selector="swordWithSpecification:">
            <argument parameterName="specification" value="blue" required-class="NSString"/>
        </initializer>
    </component>


</assembly>
```

### Using Assembled Components 

```objective-c
SpringComponentFactory componentFactory = [[SpringXmlComponentFactory alloc] 
    initWithConfigFileName:@"MiddleAgesAssembly.xml"];
Knight* knight = [_componentFactory objectForKey:@"knight"];

//This has been injected by reference
id<Quest> quest = knight.quest; 

//This has been injected by value. The container takes care of type conversion. 
NSUInteger damselsRescued = knight.damselsRescued

//This class conforms to <SpringPropertyInjectionDelegate> which has callbacks that get triggered before 
//and after properties are injected.
Knight* anotherKnight = [_componentFactory objectForKey:@"anotherKnight"];


```

# Docs

More to follow over the coming days. Meanwhile, the Tests folder contains further usage examples. 

* <a href="https://github.com/jasperblues/spring-objective-c/wiki">Wiki</a>

The API and Test Coverage reports below are published by my build server, after each commit. 

* <a href="http://jasperblues.github.com/spring-objective-c/api/index.html">API</a>
* <a href="http://jasperblues.github.com/spring-objective-c/coverage/index.html">Coverage Reports</a>

# Building 

There's a Spring Objective-C installer and IDE plugin for Xcode coming soon. Meanwhile, to integrate Spring Objective-C into your project do the following: 

*Manual* 

* Copy the files from the 'Source' directory into your project. 
* Click on the target. 
* In "other linker flags" add "-lxml2" 
* In "header search paths" add "${SDKROOT}/usr/include/libxml2" 

*CocoaPods*

Spring Objective-C is also available through <a href="http://cocoapods.org/">CocoaPods</a>

# Hacking

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


# Compatibility 

* Spring-Objective-C can be used with OSX and iOS. It has not been tested with GnuStep. It was built with ARC, but
should also work with garbage collection and 32 bit environments (more on this in the coming days). 

# Who's using it? 

* Just me so far. I had a family beach holiday booked over the Christmas/New Year period of 2012, but there was a 
late-in-season typhoon passing over the Philippines (where we live) . . . so I rolled-up my sleeves and wrote the DI
container that I'd been meaning to get around to! It's basically feature-complete for version 1.0, and over the 
coming days I'll be writing more tests and documentation.
 
 If you're using it, please shoot me an email and let me know.

#Roadmap
 
*Immediate: (coming days, help appreciated!)*

* API documentation
* ~100% test coverage. (Currently at 84%)
* A sample application. 
* Better github docs. 
* More type converters
* PropertyPlaceholderConfigurer

*Next: (coming weeks)*

* A block-based, terse code-style of component definition. 
* A IDE plugin to: a) Install the framework b) provide some tool support.
* "Annotations" and a test framework, with auto-wiring in test cases.

*Later:*

* AOP support. 

 
# Authors

* <a href="http://ph.linkedin.com/pub/jasper-blues/8/163/778">Jasper Blues</a> - <a href="mailto:jasper@appsquick.ly?Subject=spring-objective-c">jasper@appsquick.ly</a>
         
### With contributions from: 

* Your name here!!!!!!  


# LICENSE

Apache License, Version 2.0, January 2004, http://www.apache.org/licenses/

* © 2012 - 2013 jasper blues


