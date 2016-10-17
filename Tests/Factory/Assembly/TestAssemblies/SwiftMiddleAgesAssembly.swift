////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

import Foundation

open class SwiftMiddleAgesAssembly : TyphoonAssembly {
    
    open dynamic func basicKnight() -> AnyObject {
        
        return TyphoonDefinition.withClass(Knight.self) {
            (definition) in
            
            definition!.useInitializer(#selector(Knight.init(quest:))) {
                (initializer) in
                
                initializer!.injectParameter(with: self.defaultQuest())
                
            }
        } as AnyObject
    }
    
    open dynamic func defaultQuest() -> AnyObject {
        return TyphoonDefinition.withClass(CampaignQuest.self) as AnyObject
    }


    open dynamic func wanderingKnight(_ homeFort : Fort) -> AnyObject {

        return TyphoonDefinition.withClass(Knight.self) {
            (definition) in

            definition?.useInitializer(#selector(Knight.init(quest:))) {
                (initializer) in

                initializer?.injectParameter(with: self.defaultQuest())
            }
            definition?.injectProperty(#selector(getter: Knight.homeFort), with: homeFort)
        } as AnyObject
    }
    
}
