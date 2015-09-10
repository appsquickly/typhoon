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

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization
//-------------------------------------------------------------------------------------------

- (instancetype)initWithAssemblyClass:(Class)assemblyClass
{
    self = [super init];
    if (self) {
        _assemblyClass = assemblyClass;
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Public Methods
//-------------------------------------------------------------------------------------------

- (NSSet *)collectCollaboratingAssemblies
{
    NSMutableSet *collaboratorsQueue = [NSMutableSet setWithObject:self.assemblyClass];
    NSMutableSet *connectedCollaboratorClasses = [NSMutableSet set];
    
    while (collaboratorsQueue.count > 0) {
        Class currentClass = [[collaboratorsQueue allObjects] firstObject];
        NSSet *collaboratorsToCollect = [self collaboratingAssembliesForClass:currentClass withCollaboratorClasses:[connectedCollaboratorClasses copy]];
        
        for (Class collaboratorClass in collaboratorsToCollect) {
            if (![connectedCollaboratorClasses containsObject:collaboratorClass]) {
                [connectedCollaboratorClasses addObject:collaboratorClass];
                [collaboratorsQueue addObject:collaboratorClass];
            }
            
        }
        [collaboratorsQueue removeObject:currentClass];
    }
    
    NSMutableSet *collaborators = [NSMutableSet set];
    for (Class collaboratorClass in connectedCollaboratorClasses) {
        TyphoonAssembly *assemblyInstance = [collaboratorClass assembly];
        [collaborators addObject:assemblyInstance];
    }
    
    return [collaborators copy];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (NSSet *)collaboratingAssembliesForClass:(Class)inspectedClass withCollaboratorClasses:(NSSet *)collaboratorClasses
{
    NSMutableSet *collaboratorsForInspectedClass = [NSMutableSet set];
    
    NSSet *properties = [TyphoonIntrospectionUtils propertiesForClass:inspectedClass
                                                      upToParentClass:[TyphoonAssembly class]];
    
    for (NSString *propertyName in properties) {
        Class propertyClass = [TyphoonIntrospectionUtils typeForPropertyNamed:propertyName inClass:inspectedClass].typeBeingDescribed;
        
        BOOL shouldCollect = [self shouldCollectClass:propertyClass
                                               backTo:collaboratorClasses];
        if (shouldCollect) {
            [collaboratorsForInspectedClass addObject:propertyClass];
        }
    }
    
    return [collaboratorsForInspectedClass copy];
}

- (BOOL)shouldCollectClass:(Class)assemblyClass backTo:(NSSet *)classes
{
    BOOL isTyphoonAssembly = assemblyClass == [TyphoonAssembly class];
    BOOL isAlreadyCollected = [classes containsObject:assemblyClass];
    BOOL isSubclassOfTyphoonAssembly = [assemblyClass isSubclassOfClass:[TyphoonAssembly class]];
    
    return !isTyphoonAssembly && !isAlreadyCollected && isSubclassOfTyphoonAssembly;
}

@end
