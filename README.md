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

Spring is a very popular dependency injection container that is available for Java and .NET, as well as ActionScript.  

In Objective-C land, there have been a couple of dependency injection containers that follow in the footsteps of 
Google Guice. The authors have done a great job (objection is especially good), but personally I prefer a 
spring-style approach for the following reasons:

* Allows both dependency injection (injection of classes defined in the DI context) as well as configuration 
 management (values that get converted to the required type at runtime).
* Application assembly - the wiring of dependencies and configuration management - is all encapsulated in a 
convenient document. 
* Encourages polymorphism and makes it easy to have multiple implementations of the same base-class or protocol. 
 For example, let's say you have a music store application that depends on a payment engine. Spring-style makes it
easy to define both a master-card payment engine or a visa payment engine.
* Supports dependency injection by type (definitions satisfying a class or protocol) as well as by reference. 
* Also supports "annotation" (aka Macro) and code/DSL style injection.

###Isn't Objective-C a dynamic language? 

Yes, and I love categories, method swizzling, duck-typing and all that cool stuff. None of these are replacements for 
DI. DI is just a design pattern and you can do it without a container. Having one is handy though. 


# Usage

### Defining Components


```xml
<assembly xmlns="http://jasperblues.github.com/spring-objective-c/schema/assembly"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://jasperblues.github.com/spring-objective-c/schema/assembly
        http://jasperblues.github.com/spring-objective-c/schema/assembly.xsd">

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

* Just me so far. I had a family beach holiday booked over the Christmas/New Year period of 2012, but there was a 
late-in-season typhoon passing over the Philippines (where we live) . . . so I rolled-up my sleeves and wrote the DI
container that I'd been meaning to get around to! It's basically feature-complete for version 1.0, and over the 
coming days I'll be writing more tests and documentation.
 
 If you're using it, please shoot me an email and let me know.
 
# Authors

* <a href="http://ph.linkedin.com/pub/jasper-blues/8/163/778">Jasper Blues</a> - <a href="mailto:jasper@appsquick.ly?Subject=spring-objective-c">jasper@appsquick.ly</a>
         
### With contributions from: 

* Your name here!!!!!!


# LICENSE

Apache License, Version 2.0, January 2004, http://www.apache.org/licenses/

* © 2012 jasper blues


