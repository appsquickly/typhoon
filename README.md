# Description

A Spring-like dependency injection container for Objective-C. Built during a typhoon. 

## Status!!

It's ready to use:

* <a href="https://github.com/jasperblues/spring-objective-c-example">Try the sample application</a>.
* Current work: More AppCode IDE integration. (Thanks to Jetbrains for the assistance). 

### What is Dependency Injection? 

Many people have trouble getting the hang of dependency injection, at first. And I think part of the problem is that
it is actually so simple that we're inclined to look for something more complicated. "Surely that there has to be
more to it?!", so to say.  

So, with that in mind, imagine that you're writing an app that gives weather reports. You need a cloud-service 
(excuse the pun ;) ) to provide the data, and at first you go for a free weather report provider, but in future you'd 
like to integrate a weather service with better accuracy and more features. So, as do all good object-oriented 
developers, you make a WeatherClient protocol and back it initially with an implementation based on the free, online
data provider. 

___Without dependency injection, you might have a View Controller like this___: 

```objective-c

-(id) init 
{
 self = [super init];
 if (self) 
 {
 //The class using some collaborating class builds its own assistant.
 //it might be one of several classes using the weatherClient. 
  _weatherClient = [GoogleWeatherClientImpl alloc] initWithParameters:xyz];
 }
 return self;
}

```
The thing with this approach is, if you wanted to change to another weather client implementation you'd have to go
and find all the places in your code that use the old one, and move them over to the new one. Each time, making sure 
to pass in the correct initialization parameters. 

A very common approach is to have a centrally configured singleton:

```objective-c  
_weatherClient = [GoogleWeatherClient sharedInstance];
```  

With either of the above approaches, in order to test your view controller, you now have to test its collaborating 
class (the weather client) at the same time, and this can get tricky, especially as your application gets more 
complex. Imagine testing Class A, depends on Class B, depends on Class C, depends on .... Not much fun!

So with dependency injection, rather than having objects make their own collaborators, we have them supplied to the 
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


####Is that all they mean by 'injected'?
Yes it is. And if you do this with significant collaborators throughout 
your app, it means that the __GoogleWeatherClientImpl__ is now declared in a single place - the top-level assembly, 
so-to-speak. ___And___ all of the classes that need to use some kind of __id&lt;WeatherClient&gt;__ will have it passed
in. This means that: 

* If you want to change from one implementation to another, you need only change a single declaration. 
* Classes are easier to test, because we can supply simple mocks and stubs in place of concrete collaborators. Or 
the real collaborators, but configured to be used in a test scenario. (One of my design goals). 
* It promotes separation of concerns and a clear contract between classes. 
* Your app is easier to maintain and can accommodate new requirements. 




# Why Spring for Objective-C?

Well. . . it's not necessarily Spring, the well-known DI framework for Java, .NET and ActionScript. . . Just my 
personal take on what Dependency Injection should look like in Objective-C. I guess that I could've called it
'The Typhoon Framework'. Or Michael?

If you proceed with the Dependency Injection pattern _(assuming you're not one of the remaining "flat-earthers", who 
believe that Objective-C somehow magically alleviates the need for common-sense. "Oh, I don't do DI, I use swizzling 
class-clusters!")_, then there are basically two options: 

* You can do dependency injection without a framework/library/container to help you. It ___is___ simple after all, and in 
fact I recommend you do this, at least as an exercise in software design. And yes, it is certainly possble that this will be 
adequate. ___But___, I think its good to have help, if you can get it. 

* So, going down the library/framework route, there's been quite a lot of action in Objective-C land, over the last 
three years. There are now around 15 Dependency Injection frameworks, many following in the footsteps of Google Guice. 
The authors have done a great job (Objection is especially good). However, I wanted an approach that allows the 
following: 

## Design Goals / Features

* Dependencies declared in any order. (The order that makes sense to humans).

* Allows both dependency injection (injection of classes defined in the DI context) as well as configuration 
 management (values that get converted to the required type at runtime). Because this allows. . . 
 
* . . . ability to configure components for use in eg ___Test___ vs ___Production___ scenarios. This faciliates a 
good compromise between integration testing and pure unit testing. (Biggest testing bang-for-your-buck). 
 
* Application assembly - the wiring of dependencies and configuration management - is all encapsulated in a 
convenient document. Now you know where to look if you need to change something. 

* Non-invasive.

* Encourages polymorphism and makes it easy to have multiple implementations of the same base-class or protocol. 
Supports both auto-wiring by type and wiring-by-reference. 

* Supports both initializer and property injection. In the case of the latter, it has customizable call-backs to 
ensure that the class is in the required state before and after properties are set. 

* Flexibility. Supports different approaches of dependency injection for different scenarios, including "annotations"
and GUI tool-support. 

### So, does this mean XML? 

When I say Spring-like, I mean that it supports the above features. It does not necessarily mean XML at all! (Spring 
for Java doesn't imply XML either). ___To give the above benefits requires that the component definitions be interpreted 
at runtime.___ Otherwise you run into problems with the order of definition of components, type conversion, and 
others that you're probably not interested in hearing about, unless you're writing a DI container of your own. 

___So what are the options for runtime interpretation of component recipes?___

#### Annotations

"Annotations" (aka Macros) have their place, but they don't really provide the modularization of concerns or 
configuration management options that I'm after. (I will be supporting them, and I do like them for test cases).

So that leaves: 

#### DSL
I thought about writing an interpreted, domain-specific language (DSL). This is certainly a fun exercise in the 
use of <a href="http://en.wikipedia.org/wiki/Compiler-compiler">compiler compilers</a>. However it would be: 

* Just another language that people will need to learn, given that there is no current standard. 
* Would pose additional overhead on memory and CPU-constrained devices. Like the Objective-C runtime, I want 
something thin enough as to be hardly there. 


#### GUI Tool

Still an option and it could be really neat, but in the experience of my friends at Jetbrains 
"a text-editor approach is more convenient and fluent than GUI-based approach." You're a developer after all right, 
And while Interface Builder is super cool, do you use it to write serious apps? Also it would cost a lot to develop, 
and I don't have the time or money right now. 


__So the XML is the winner. It provides the features that I stated above. And also:__ 

* There's already a defacto or recognized standard with the Spring-style approach in Java, .NET and ActionScript.  
* Evyeryone knows XML. 
* It provides very low overhead, so is compatible with memory and CPU-constrained devices. 
* There's nothing new to learn, because, its very easy to provide code-completion and hints. As it stands now, 
I have schema-based completion, which is pretty cool. And I'm working with the Jetbrains team to provide more code 
introspections for <a href="http://www.jetbrains.com/objc/">AppCode</a> so you get initializer, selector and property-name 
completion. 
* It can still be used as the foundation for a future GUI-tool - this is what Apple does with Interface Builder and 
StoryBoards. 


#### Reams of it?

There's been a criticism that the XML is verbose and un-readable. If you take a look at the <a href="https://github.com/jasperblues/spring-objective-c-example">sample application</a> 
you'll see that this is ___simply not true___. There is not much of it, and what there is can be grouped and modularized 
appropriately. 

The argument comes from those with a vested interest in another approach, and was actually the same one that was used
by Google in defense of their Guice container when it came out. (But not at all by Justin in relation to his Guice-like
DI container for Objective-C).

At the time the argument was partially successful because we were still in the midst of the XML hangover after 
___everyone___ had to have XML on their product sheet in the early 2000s. It's a little ironic that we were all 
seemingly unaware of being caught-up in the sebsequent ___annotation craze___ with a new annotation coming out every 
week. But I think, we're over both of those now, and in the words of Bruce Lee " 'tations are tations, and XML is just XML". 

# Usage

* <a href="https://github.com/jasperblues/spring-objective-c-example">Play with the sample application</a>.

And then:

* <a href="https://github.com/jasperblues/spring-objective-c/wiki/Assembling-Components">Assembling Components</a>

* <a href="https://github.com/jasperblues/spring-objective-c/wiki/Using-Assembled-Components">Using Assembled Components</a>

* <a href="https://github.com/jasperblues/spring-objective-c/wiki/Incorporating">Incorporating the framework into your project.</a>

# Reports

In the spirit of lean-methodologies, the API and Test Coverage reports below are published by my build server, after 
each commit. (If you'd like the script I will share it). 

* <a href="http://jasperblues.github.com/spring-objective-c/api/index.html">API</a>
* <a href="http://jasperblues.github.com/spring-objective-c/coverage/index.html">Coverage Reports</a>



# Feature Requests and Contributions

. . . are very welcome. 

* <a href="https://github.com/jasperblues/spring-objective-c/wiki/Contribution-Guide">Contribution Guide.</a>

* Look at and contribute to the <a href="https://github.com/jasperblues/spring-objective-c/wiki/Roadmap">roadmap</a> here.

# Frequently Asked Questions

. . . are <a href="https://github.com/jasperblues/spring-objective-c/wiki/FAQ">here</a>.


# Who's using it? 

* Mod Productions - Two applications currently in development. 
 
 If you're using it, please shoot me an email and let me know.


# Authors

* <a href="http://ph.linkedin.com/pub/jasper-blues/8/163/778">Jasper Blues</a> - <a href="mailto:jasper@appsquick.ly?Subject=spring-objective-c">jasper@appsquick.ly</a>
         
### With contributions from: 

* Jeffrey Roberts, Mobile Software Engineer at Riot Games, previous contributor to Swiz for ActionScript. . . Feedback and testing. 


# LICENSE

Apache License, Version 2.0, January 2004, http://www.apache.org/licenses/

* © 2012 - 2013 jasper blues


