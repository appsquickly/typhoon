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

import Foundation
import Typhoon

open class Assembly: TyphoonAssembly {
    
    open dynamic func viewController() -> AnyObject {
        return TyphoonDefinition.withClass(ViewController.self) { definition in
            definition!.injectProperty("foo", with: "bar")
        } as AnyObject
    }
}
