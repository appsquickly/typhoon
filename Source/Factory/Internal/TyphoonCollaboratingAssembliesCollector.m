////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonCollaboratingAssembliesCollector.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonAssembly.h"
#import "TyphoonTypeDescriptor.h"

@interface TyphoonCollaboratingAssembliesCollector ()

@property (nonatomic, assign) Class assemblyClass;

@end

@implementation TyphoonCollaboratingAssembliesCollector

- (instancetype)initWithAssemblyClass:(Class)assemblyClass {
    self = [super init];
    if (self) {
        _assemblyClass = assemblyClass;
    }
    return self;
}

- (NSSet *)collaboratingAssembliesForClass:(Class)assemblyClass withCollaboratorClasses:(NSSet *)collaboratorClasses {
    NSMutableSet *result = [NSMutableSet set];
    NSSet *properties = [TyphoonIntrospectionUtils propertiesForClass:assemblyClass
                                                      upToParentClass:[TyphoonAssembly class]];
    for (NSString *propertyName in properties) {
        Class collaboratingAssemblyClass = [TyphoonIntrospectionUtils typeForPropertyNamed:propertyName inClass:assemblyClass].typeBeingDescribed;
        BOOL shouldCollect = [self shouldCollectCollaboratingAssembliesForClass:collaboratingAssemblyClass backTo:collaboratorClasses];
        if (shouldCollect) {
            [result addObject:collaboratingAssemblyClass];
        }
    }
    
    return [result copy];
}

- (NSSet *)collectCollaboratingAssembliesBackToClasses:(NSSet *)classes {
    NSMutableSet *queue = [NSMutableSet setWithObject:self.assemblyClass];
    NSMutableSet *connectedCollaboratorClasses = [NSMutableSet set];
    
    while (queue.count > 0) {
        Class currentClass = [[queue allObjects] firstObject];
        NSSet *collaboratorsToCollect = [self collaboratingAssembliesForClass:currentClass withCollaboratorClasses:[connectedCollaboratorClasses copy]];
        
        for (Class collaboratorClass in [collaboratorsToCollect allObjects]) {
            if (![connectedCollaboratorClasses containsObject:collaboratorClass]) {
                [connectedCollaboratorClasses addObject:collaboratorClass];
                [queue addObject:collaboratorClass];
            }
            
        }
        [queue removeObject:currentClass];
    }
    
    NSMutableSet *collaborators = [NSMutableSet set];
    for (Class collaboratorClass in [connectedCollaboratorClasses allObjects]) {
        TyphoonAssembly *assemblyInstance = (TyphoonAssembly *)[collaboratorClass assembly];
        [collaborators addObject:assemblyInstance];
    }
    
    return [collaborators copy];
}

- (BOOL)shouldCollectCollaboratingAssembliesForClass:(Class)assemblyClass
                                              backTo:(NSSet *)classes
{
    BOOL isTyphoonAssembly = assemblyClass == [TyphoonAssembly class];
    BOOL isAlreadyCollected = [classes containsObject:assemblyClass];
    BOOL isSubclassOfTyphoonAssembly = [assemblyClass isSubclassOfClass:[TyphoonAssembly class]];
    
    return isTyphoonAssembly && isAlreadyCollected && isSubclassOfTyphoonAssembly;
}

@end
