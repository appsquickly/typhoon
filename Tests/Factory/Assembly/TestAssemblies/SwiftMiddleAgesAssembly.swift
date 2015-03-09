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

public class SwiftMiddleAgesAssembly : TyphoonAssembly {
    
    public dynamic func basicKnight() -> AnyObject {
        
        return TyphoonDefinition.withClass(Knight.self) {
            (definition) in
            
            definition.useInitializer("initWithQuest:") {
                (initializer) in
                
                initializer.injectParameterWith(self.defaultQuest())
                
            }
        }
    }
    
    public dynamic func defaultQuest() -> AnyObject {
        return TyphoonDefinition.withClass(CampaignQuest.self)
    }


    public dynamic func wanderingKnight(homeFort : Fort) -> AnyObject {

        return TyphoonDefinition.withClass(Knight.self) {
            (definition) in

            definition.useInitializer("initWithQuest:") {
                (initializer) in

                initializer.injectParameterWith(self.defaultQuest())
            }
            definition.injectProperty("homeFort", with: homeFort)
        }
    }
    
}