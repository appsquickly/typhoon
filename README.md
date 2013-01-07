# Description

A Spring-like dependency injection container for Objective-C. Built during a typhoon. 

##New! 
Check out the example at: https://github.com/jasperblues/spring-objective-c-example

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

Also, in order to test your view controller, you now have to test its collaborating class - ___the weather client___ - 
at the same time, and this can get tricky, especially as your application gets more complex. Imagine testing 
Class A, depends on Class B, depends on Class C, depends on .... Not much fun!

So with dependency injection, rather than having objects make their own collaborators we have them supplied to the 
class instance via an initializer or property setter.

___And now, it simply becomes___: 

```objective-c

-(id) initWithWeatherClient:id<WeatherClient>weatherClient
{
 self = [super init];
 if (self) 
 {
     _weatherClient = weatherClient;
 }
 return self;
}

```

___Is that all they mean by 'injected'?___. Yes it is. And if you do this throughout your app, it means that the 
GoogleWeatherClientImpl is now declared in a single place - the top-level assembly, so-to-speak. ___And___ all of the 
classes that need to use some kind of id&lt;WeatherClient&gt; will have it passed in. This means that: 

* If you want to change from one implementation to another, you need only change a single declaration. 
* Classes are easier to test, because we can supply simple mocks and stubs in place of concrete collaborators. Or the real collaborators, but configured to be used in a test scenario.
* It promotes separation of concerns and a clear contract between classes. 
* Your app is easier to maintain and can accommodate new requirements. 


### Why Spring for Objective-C?

Well. . . it's not necessarily Spring. Just my personal take on what Dependency Injection should look like in 
Objective-C. I guess that I could've called it ___'The Typhoon Framework'.___ 

First of all, based on the above definition - you can do dependency injection without a container, if you want to.  
It helps to have one though. In Objective-C land, there have been a couple of dependency injection containers that 
follow in the footsteps of Google Guice. The authors have done a great job (Objection is especially good), however I 
wanted an approach that allows the following: 

* Dependencies declared in any order. (The order that makes sense to humans).

* Allows both dependency injection (injection of classes defined in the DI context) as well as configuration 
 management (values that get converted to the required type at runtime). Because this allows. . . 
 
* . . . ability to configure components for use in eg ___Test___ vs ___Production___ scenarios. This faciliates a 
good compromise between integration testing and pure unit testing. (Biggest testing bang-for-your-buck). 
 
* Application assembly - the wiring of dependencies and configuration management - is all encapsulated in a 
convenient document. Now you know where to look if you need to change something. 

* Non-invasive.

* Encourages polymorphism and makes it easy to have multiple implementations of the same base-class or protocol. 
Supports both auto-wiring and wiring-by-reference. 

* Supports both initializer and property injection. In the case of the latter has customizable call-backs to ensure
the class is in the required state before usage. 


. . Initially I've provided an XML implementation, because it was the fastest way I could satisfactorily meet 
the above goals. It's already fast and effective, especially if you use AppCode with XML-schema completion. I have 
other DI-styles planned, including "annotations" and GUI tool-support. 


# Usage


* <a href="https://github.com/jasperblues/spring-objective-c/wiki/Assembling-Components">Assembling Components</a>

* <a href="https://github.com/jasperblues/spring-objective-c/wiki/Using-Assembled-Components">Using Assembled Components</a>

* <a href="https://github.com/jasperblues/spring-objective-c/wiki/Incorporating">Incorporating the framework into your project.</a>

# Reports

The API and Test Coverage reports below are published by my build server, after each commit. 

* <a href="http://jasperblues.github.com/spring-objective-c/api/index.html">API</a>
* <a href="http://jasperblues.github.com/spring-objective-c/coverage/index.html">Coverage Reports</a>



# Feature Requests and Contributions

. . . are very welcome. 

* <a href="https://github.com/jasperblues/spring-objective-c/wiki/Contribution-Guide">Contribution Guide.</a>

* Look at and contribute to the <a href="https://github.com/jasperblues/spring-objective-c/wiki/Roadmap">roadmap</a> here.

# Frequently Asked Questions

. . . are <a href="https://github.com/jasperblues/spring-objective-c/wiki/FAQ">here</a>.


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

* © 2012 - 2013 jasper blues


