# Description

A Spring-like dependency injection container for Objective-C. Built during a typhoon. 

## Status? It's ready to use!

* <a href="https://github.com/jasperblues/spring-objective-c-example">Try the sample application</a>.
* Current work: More <a href="http://www.jetbrains.com/objc/">AppCode IDE</a> integration. (Thanks to Jetbrains for the assistance). 

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
'The Typhoon Framework'. Or Michael? I don't work at SpringSource. I did once. . .  but I ran away with a girl and now
live in Manila, Philippines. Shortly after that SpringSource was sold to VmWare for $400M, so a lot of people got serious
money. . .  meanwhile I got two lovely children, and a very lovely wife. ___In summary___: I'm not getting any financial 
benefit from this. I'm doing it because I think it is the right thing to do.

### Your Dependency Injection Options

If you proceed with the Dependency Injection pattern _(assuming you're not one of the remaining "flat-earthers", who 
believe that Objective-C somehow magically alleviates the need for common-sense: "Oh, I don't do DI, I use swizzling 
class-clusters!")_, then there are basically two options: 

* You can do dependency injection without a framework/library/container to help you. It ___is___ simple after all, and in 
fact I recommend you do this, at least as an exercise in software design. And yes, it is certainly possble that this will be 
adequate. ___But___, I think its good to have help, if you can get it. You can also write tests without a test 
framework, mocks with out a mock library, software without a compiler/interpreter. 

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
 
* Application assembly - the wiring of dependencies and configuration management - is all encapsulated in a 
convenient document. Now you know where to look if you need to change something. 

* Non-invasive.

* Encourages polymorphism and makes it easy to have multiple implementations of the same base-class or protocol. 
Supports both auto-wiring by type and wiring-by-reference. 

* Supports both initializer and property injection. In the case of the latter, it has customizable call-backs to 
ensure that the class is in the required state before and after properties are set. 

* Flexibility. Supports different approaches of dependency injection for different scenarios, including "annotations"
and GUI tool-support. 

* Lean. It has a very low footprint, so is appropriate for CPU and memory constrained devices. 

## So, does this mean XML? 

___(I'll move this discussion to the <a href="https://github.com/jasperblues/spring-objective-c/wiki/FAQ">FAQ</a> later, but its
currently the hot topic for discussion, now that we've established the case for Dependency Injection in Objective-C 
. . . If you like, you can skip straight to the Usage section).___

When I say Spring-like, I mean that it supports the above design goals and features. It does not necessarily mean XML 
at all! (Spring for Java doesn't imply XML either). ___To give the above benefits, requires that the component 
definitions be interpreted at runtime.___ Otherwise you run into problems with the order of declarations, transitive 
dependencies, type conversion, and others that you wouldn't be interested in hearing about, unless you're rolling 
your own DI. 

___So what, then, are the options for runtime interpretation of component recipes?___

#### Pure Objective-C API

This is 
<a href="https://github.com/jasperblues/spring-objective-c/blob/master/Tests/Factory/SpringComponentFactoryTests.m">already supported</a>, 
however I find it too verbose to be of practical use. It certainly gets you a couple of steps ahead, by allowing you to 
define components in any order, as well as inject by type, reference and value. And with properties or initializers. Its 
the foundation of what is built on top. 

#### Annotations

"Annotations" (aka faking them with Macros in Objective-C) have their place, but they don't really provide the 
modularization or configuration management options that I'm after. (I will be supporting them, and I do 
like them for test cases).

What else?

#### Domain Specific Language
I thought about writing an interpreted, domain-specific language (DSL). This is certainly a fun exercise in the 
use of <a href="http://en.wikipedia.org/wiki/Compiler-compiler">compiler compilers</a> (or should that be _interpreter interpreters_ ;) ). But I think it would be: 

* Just another language that people will need to learn, given that there is no current standard. 
* Would pose additional overhead on memory and CPU-constrained devices. Like the Objective-C runtime, I want 
something thin enough as to be hardly there. This way the framework can be used in demanding applications, like games 
and augmented reality. (Because 2013 is the year of Augmented Reality, right?) 


#### GUI Tool

Still an option and it could be really neat, but in the experience of my friends at Jetbrains 
"a text-editor approach is more convenient and fluent than GUI-based approach." You're a programmer after all right? 
Also it would cost a lot to develop. . . and I don't have the time or money right now. (If you want to give me some 
I will do it!!!!)

#### JSON (. . . the f@#$*@* ????) 

One of my vociferous critics on Twitter (a well-known individual), suggested . . . 
wait for it . . (but if you're currently having a drink get ready to spray it all over the place) . . . Ready? .
. . ___"JSON!"___ . . I kid you not. . . .
I guess the only thing I can say is that if you want to write a JSON extension for your own use, then 
the container <a href="http://jasperblues.github.com/spring-objective-c/api/Classes/SpringComponentFactory.html">fully supports that</a>. 


####So XML is the winner. It provides the features that I stated above. And also:

* There's already a defacto or recognized standard with the Spring-style approach in Java, .NET and ActionScript. These 
are communities we can tap, as we get into DI with Objective-C. 
* Evyeryone knows XML. 
* As for learning the markup: You don't need to, because there's code-completion and hints. Right now, I have 
schema-based completion, which is pretty cool. And I'm working with the Jetbrains team, who make the brilliant 
<a href="http://www.jetbrains.com/objc/">AppCode IDE</a>. They're kindly opening up their previously private APIs 
which will allow more code introspections. So you get completion/validation on initializer, selector and 
property-names, as well as checks on all of your components wired by reference. 
* It provides very low overhead, so is compatible with memory and CPU-constrained devices. (I mentioned this before 
but its worth mentioning again). 
* It can still be used as the foundation for a future GUI-tool - this is what Apple does with Interface Builder and 
StoryBoards. Great build-time tools, lean runtime. 


#### _Reams_ of it?!?

Wait. .  We're still not done yet. One last thing: There's been a criticism that the XML is "tangled, un-readable", "pages and pages long", "heavy-weight", 
and (my favorite) ___"It suddenly came out of my old dot-matrix printer, like the sirens of death on 
the night the world ended!"___ (actually, I made that one up myself). . . . ___Stop the press!___. . . 
If you take a look at the <a href="https://github.com/jasperblues/spring-objective-c-example">___sample application___</a> 
you'll see that this is <a href="https://github.com/jasperblues/spring-objective-c-example/blob/master/PocketForecast/Assembly.xml">___simply not true___</a>. 
There is not much of it, it looks just fine and what there is can be 
<a href="https://github.com/jasperblues/spring-objective-c-example/blob/master/PocketForecast/ViewControllers.xml">___grouped and modularized appropriately.___</a>

The argument actually ___comes from those with a vested interest in another approach___, and was the ___same one that was used
by Google to go on the offensive against Spring, when their own Guice container was released___. _(NB: But not at all by Justin in relation to his Guice-like
DI container for Objective-C. I admire Justin's work and moreover his personal integrity when he defended mine despite having a competing solution)._

So anyway, at the time Google/Guice brought that argument up, it was partially successful. Because? Back then around year
2008 we were still in the midst of a hangover after ___everyone___ had to have XML on their product sales-pitch in the 
early 2000s. For a while there, it was the classic _builder with a new hammer and everything looks like a nail_ story. What's funny 
and ironic is that we were all unaware about being caught-up in the subsequent ___annotation craze___ that followed!. 
Its 2013 and I think we're over both of those phases now. They both have their valid uses. In the words of 
<a href="http://shutterfinger.typepad.com/shutterfinger/2011/02/in-martial-arts-as-in-life-you-dont-win-the-trophy-without-a-fight-before-i-learned-the-art-a-punch-was-just-a-punch-an.html">Bruce Lee</a> -- _"Annotations are annotations, and XML is XML"_. 

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

* Look at, and contribute to the <a href="https://github.com/jasperblues/spring-objective-c/wiki/Roadmap">roadmap</a> here.

# Frequently Asked Questions

. . . are <a href="https://github.com/jasperblues/spring-objective-c/wiki/FAQ">here</a>.


# Who's using it? 

* <a href="http://modprods.com">Mod Productions</a> : Two very exciting applications currently in development. Stay tuned for release.
 
 If you're using it, please shoot me an email and let me know.


# Authors

* <a href="http://ph.linkedin.com/pub/jasper-blues/8/163/778">Jasper Blues</a> - <a href="mailto:jasper@appsquick.ly?Subject=spring-objective-c">jasper@appsquick.ly</a>
         
### With contributions from: 

* Jeffrey Roberts, Mobile Software Engineer at Riot Games, previous contributor to Swiz for ActionScript : Feedback and testing. 
* John Blanco of Rapture in Venice, LLC : contributed his 
<a href="https://github.com/ZaBlanc/RaptureXML">lean and elegant XML library</a>. A great example that full-featured
is not the same as heavy. 
 
* <a href="http://www.jetbrains.com/">Jetbrains</a>, maker of very cool software development tools : Assistance with AppCode integration. 

Thanks!!!


# LICENSE

Apache License, Version 2.0, January 2004, http://www.apache.org/licenses/

* © 2012 - 2013 jasper blues


