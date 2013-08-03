Consider a class `Moat` with a single property `filledWith`. Say your application uses a moat filled with lava somewhere in the code, and a moat filled with (relatively) harmless water somewhere else. Currently, you need four methods in the assembly returning definitions:

      - (id)moatFilledWithLava;
      - (id)moatFilledWithWater;
      - (id)lava;
      - (id)water;

But what if you could do this?

    - (id)moatFilledWith:(id)aDangerousLiquid;
    - (id)lava;
    - (id)water;

You'd still usually want to create the specific definitions for clients to use:

    - (id)moatFilledWithLava;
    - (id)moatFilledWithWater;

But, if you have parameterized definition methods, you can extract any duplication from these methods easily. Say the moat also requires a bridge, which your application has one definition for:

    - (id)bridge;

Currently you must:

    - (id)moatFilledWithWater;
    {
        return [TyphoonDefinition withClass:[Moat class] properties:^(TyphoonDefinition *definition) {
            [definition injectProperty:@selector(filledWith) withDefinition:[self water]];
            [definition injectProperty:@selector(bridge)];
        }];
    }
  
    - (id)moatFilledWithLava;
    {
        return [TyphoonDefinition withClass:[Moat class] properties:^(TyphoonDefinition *definition) {
            [definition injectProperty:@selector(filledWith) withDefinition:[self lava]];
            [definition injectProperty:@selector(bridge)];
        }];
    }

Or something like:

    - (TyphoonDefinitionBlock)sharedDefinitionsForMoat
    {
        return ^(TyphoonDefinition *definition) {
            [definition injectProperty:@selector(bridge)];
        };
    }

The bridge property is duplicated. You can now extract this duplication.

    - (id)moatFilledWithWater;
    {
      return [self moatFilledWith:[self water]];
    }
  
    - (id)moatFilledWithLava;
    {
      return [self moatFilledWith:[self lava]];
    }
  
    - (id)moatFilledWith:(id)aDangerousLiquid;
    {
        return [TyphoonDefinition withClass:[Moat class] properties:^(TyphoonDefinition *definition) {
            [definition injectProperty:@selector(filledWith) withDefinition:aDangerousLiquid];
            [definition injectProperty:@selector(bridge)];
        }];
    }

This wasn't the original idea that motivated me, though. What I was looking for was a parameterized provider, which would allow me to pass in an object constructed dynamically into a factory method and get back a constructed instance. Currently, if you need to do this, you have to failover to constructing objects manually. You lose the viral construction provided by DI, which means that all objects that are dependencies of the object you want to dynamically construct (with a parameter) must also be constructed by hand.

I have an object that takes a core data stack constructed at runtime, and I want to do this:

    coreDataStack = [assembly mainStack]; // this is a singleton
    aNewStack = [assembly childStackOf:coreDataStack]; 
    [assembly refresherOnStack:aNewStack];

On second thought, I could just have a definition for a child stack inside of DI, and do this:

    [assembly refresherOnChildStack];

But for the sake of argument lets say this parameter has to be constructed outside of DI.

    - (id)refresherOnStack:(id)coreDataStack;
    {
        return [TyphoonDefinition withClass:[Refresher class] initialization:^(TyphoonInitializer *initializer) {
            initializer.selector = @selector(initWithConsumer:);
            
            [initializer injectWithDefinition:[self consumerOnStack:coreDataStack]];
        }];
    }
    
    - (id)consumerOnStack:(id <RHGCoreDataStack>)coreDataStack;
    {
        return [TyphoonDefinition withClass:[Consumer class] initialization:^(TyphoonInitializer *initializer) {
            initializer.selector = @selector(initWithAPIClient:coreDataStack:someStaticDependency:);
            
            [initializer injectWithDefinition:[self apiClient]];
            [initializer injectWithRuntimeObjectOrDefinition:coreDataStack];
            [initializer injectWithDefinition:[self someStaticDependency]];
        }];
    }
    
    - (id)someStaticDependency;
    {
        return [TyphoonDefinition withClass:[someStaticDependency class]];
    }


If you had something that depended on a notification center, then you could write:

    - (id)notifier
    {
        return [TyphoonDefinition withClass:[Notifier class] initialization:^(TyphoonInitializer *initializer) {
            initializer.selector = @selector(initWithNotifier);
            
            [initializer injectWithRuntimeObject:[NSNotificationCenter defaultCenter]]; // bad, because you'll be duplicating the details of constructing the notification center all over your DI assembly.
        }];
    }

Better yet:

    - (id)notifier
    {
        return [TyphoonDefinition withClass:[Notifier class] initialization:^(TyphoonInitializer *initializer) {
            initializer.selector = @selector(initWithNotifier);
            
            [initializer injectWithRuntimeObjectOrDefinition:[self notificationCenter]];
        }];
    }
  
With:

    - (id)notificationCenter
    {
        return [NSNotificationCenter defaultCenter];
    }
  
OR

    - (id)notificationCenter
    {
        return [TyphoonDefinition withClass:[NSNotificationCenter class] initialization:^(TyphoonInitializer *initializer) {
            initializer.selector = @selector(defaultCenter);
        }];
    }

Returning a definition seems cleaner (and might actually end up being necessary due to some complexity I haven't forseen). But just calling the method instead of specifying how to call the method is certainly simpler.

**JB Points:**

* You can currently inject a 'raw object'. . . this code hasn't been well-tested yet. . It does seem to help to unify the method to inject either a definition or a type. . Would this lead to any cognitivie dissonance regarding type safety/clarity?
* Certainly faster to type the short-hand for simple objects. 
* Another 'option' (or related feature) is we have pre-canned common singletons. 
