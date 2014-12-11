//
//  Assembly.swift
//  Typhoon
//
//  Created by mike.owens on 12/8/14.
//  Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

import Foundation
import Typhoon

public class Assembly: TyphoonAssembly {
    
    public dynamic func viewController() -> AnyObject {
        return TyphoonDefinition.withClass(ViewController.self) { definition in
            definition.injectProperty("foo", with: "bar")
        }
    }
}