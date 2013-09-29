![Build Status](http://appsquick.dyndns.org:8080/buildStatus/icon?job=Typhoon)

# Typhoon! (www.typhoonframework.org) 

A new dependency injection container for Objective-C. Light-weight, yet full-featured and super-easy to use. 


## Familiar with Dependency Injection?

* <a href="https://github.com/jasperblues/Typhoon/wiki/Assembling-Components-with-Blocks">Read the User Guide</a>.
* <a href="https://github.com/jasperblues/Typhoon-example">Try the sample application</a>.
* <a href="https://github.com/jasperblues/Typhoon#design-goals--features">Check the feature list</a>.

otherwise. . . 

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
  _weatherClient = [[GoogleWeatherClientImpl alloc] initWithParameters:xyz];
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

_Sure, you could patch out the singleton with a mock or a stub, but this requires peeking inside the code to find the
dependencies. Besides taking time that could be better spent else-where, this ends up becoming "glass-box" testing as
opposed to "black-box" testing. Isn't it better to be able to test the external interface to a class, without having 
worry about what's going on inside? _And_ you have to remember un-patch again at the end of the test-case or risk 
strange breakages to other tests, where its difficult to pin-point what the real problem is might be._ . . 

. . . So with dependency injection, rather than having objects make their own collaborators, we have them supplied to the 
class instance via an initializer or property setter.

___And now, it simply becomes___: 

```objective-c

-(id) initWithWeatherClient:(id<WeatherClient>)weatherClient
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
Yes it is. Right now, you might be thinking "Geez! That's a pretty fancy name for something so plain." Well, you'd be right. But let's look at the implications on our application architecture: If you do this with significant collaborators throughout your app, it means that the __GoogleWeatherClientImpl__ is now declared in a single place - the top-level assembly, so-to-speak. ___And___ all of the classes that need to use some kind of __id&lt;WeatherClient&gt;__ will have it passed in. This means that: 

* If you want to change from one implementation to another, you need only change a single declaration. 
* Classes are easier to test, because we can supply simple mocks and stubs in place of concrete collaborators. Or 
the real collaborators, but configured to be used in a test scenario. (One of my design goals). 
* It promotes separation of concerns and a clear contract between classes. Its easy to see what each class needs in order
to do its job. 
* Your app is easier to maintain and can accommodate new requirements. 


# Your Dependency Injection Options

If you proceed with the Dependency Injection pattern _(assuming you're not one of the remaining "flat-earthers", who 
believe that Objective-C somehow magically alleviates the need for common-sense: "Oh, I don't do DI, I use swizzling 
class-clusters!")_, then there are basically two options: 

* You can do dependency injection without a framework/library/container to help you. It ___is___ simple after all, and in 
fact I recommend you do this, at least as an exercise in software design. And yes, it is certainly possble that this will be 
adequate. ___But___, I think its good to have help, if you can get it. You can also write tests without a test 
framework, mocks with out a mock library, software without a compiler. 

* So, going down the library/framework route, there's been quite a lot of action in Objective-C land, over the last 
three years. In fact, there are now around 15 Dependency Injection frameworks, many following in the footsteps of Google Guice. 
The authors have done a great job (Objection is especially good). However, I wanted an approach that allows the 
following: 

## Design Goals / Features

* Dependencies declared in any order. (The order that makes sense to humans).

* Allows both dependency injection (injection of classes defined in the DI context) as well as configuration 
 management (values that get converted to the required type at runtime). Because this allows. . . 
 
* . . . ability to configure components for use in eg ___Test___ vs ___Production___ scenarios. This faciliates a 
good compromise between integration testing and pure unit testing. (Biggest testing bang-for-your-buck). 

* ***Doesn't get all "meta" on you. Supports auto-wiring "annotations" (macros), for simple cases. When convention-over-configuration doesn't provide a simple answer, it 
gets straight-to-the-point by defining what depends on what.*** 

* No fragmented qualifier macros, modules, etc. Makes it easy to have multiple configurations of the same base-class or protocol. 
 
* Application assembly - the wiring of dependencies and configuration management - is all encapsulated in a 
convenient document. At the same time this document can be grouped into chapters. Now you know where to look if you need to change something. 

* Non-invasive. Its not necessary to change ***any*** of your classes to use the framework. It does not swizzle your classes, so you can use the same class with or without dependency injection. 

* Supports both initializer and property injection. In the case of the latter, it has customizable call-backs to 
ensure that the class is in the required state before and after properties are set. 

* Flexibility. Supports different approaches of dependency injection for different scenarios - native block-style, auto-wiring macros or Spring-style XML.

* Excellent support for circular dependencies. 

* Lean. It has a very low footprint, so is appropriate for CPU and memory constrained devices. 


# Usage

* <a href="https://github.com/jasperblues/Typhoon-example">Play with the sample application</a>.

And then:

* <a href="https://github.com/jasperblues/Typhoon/wiki/Assembling-Components-with-Blocks">Assembling Components with Blocks (recommended) </a> ___or___ <a href="https://github.com/jasperblues/Typhoon/wiki/Assembling-Components-in-XML">Assembling Components in XML</a>

* <a href="https://github.com/jasperblues/Typhoon/wiki/Autowiring">Autowiring</a>

* <a href="https://github.com/jasperblues/Typhoon/wiki/Using-Assembled-Components">Using Assembled Components</a>

* <a href="https://github.com/jasperblues/Typhoon/wiki/Incorporating">Incorporating the framework into your project.</a>

* <a href="https://github.com/jasperblues/Typhoon/wiki/Configuration-Management-&amp;-Testing">Configuration Management & Testing.</a>

# Reports

In the spirit of lean-methodologies, the API and Test Coverage reports below are published by my build server, after 
each commit. (If you'd like the script I will share it). 

* <a href="http://jasperblues.github.com/Typhoon/api/index.html">API</a>
* <a href="http://jasperblues.github.com/Typhoon/test-results/index.html">Test Results</a>
* <a href="http://jasperblues.github.com/Typhoon/coverage/index.html">Coverage Reports</a>



# Feature Requests and Contributions

. . . are very welcome. 

* <a href="https://github.com/jasperblues/Typhoon/wiki/Contribution-Guide">Contribution Guide.</a>

* Look at, and contribute to the <a href="https://github.com/jasperblues/Typhoon/wiki/Roadmap">roadmap</a> here.


# Got a question? Need some help? 

* We monitor the Typhoon tag on <a href="http://stackoverflow.com/questions/tagged/typhoon?sort=newest&pageSize=15">Stack Overflow</a>.
* Professional consultation is available from key contributors. If something you're interested in, please get in touch. 


# Core Team

* <a href="http://ph.linkedin.com/pub/jasper-blues/8/163/778">Jasper Blues</a> - <a href="mailto:jasper@appsquick.ly?Subject=Typhoon">jasper@appsquick.ly</a>
* <a href="https://github.com/rhgills">Robert Gilliam</a> - <a href="mailto:robert@robertgilliam.org?Subject=Typhoon">robert@robertgilliam.org</a>
         
### With contributions from: 

* <a href="https://github.com/eriksundin">Erik Sundin</a> : Initilizer collections, infrastructure components for post-processors.  
* <a href="https://github.com/cesteban">César Estébanez Tascón</a> : Circular Dependencies fixes. 
* <a href="https://github.com/BrynCooke">Bryn Cooke</a> : Late injections & story board integration. 
* <a href="http://www.linkedin.com/in/jeffreydroberts">Jeffrey Roberts</a>, Mobile Software Engineer at 
<a href="http://www.riotgames.com/">Riot Games</a>, previous contributor to Swiz for ActionScript : Advice, feedback and testing. 
* John Blanco of Rapture in Venice, LLC : contributed his 
<a href="https://github.com/ZaBlanc/RaptureXML">lean and elegant XML library</a>. A great example that full-featured
is not the same as heavy. 
* <a href="http://www.jetbrains.com/">Jetbrains</a>, maker of very cool software development tools : Assistance with AppCode integration. 
* <a href="http://es.linkedin.com/in/josegonzalezgomez/">José González Gómez</a>, Mobile and cloud developer at OPEN input : Feedback; testing, support for property placeholders in initializers. 
* ___Your name here!!!!!!!___ 

*(If you've sent a pull request and didn't get a mention. . . sorry! Please let us know and we'll correct it).*

****


# LICENSE

Apache License, Version 2.0, January 2004, http://www.apache.org/licenses/

© 2012 - 2013 Jasper Blues and contributors.

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/0e47e2f2028b2badfc88e13f95914938 "githalytics.com")](http://githalytics.com/jasperblues/Typhoon)
