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
import XCTest


class SwiftTyphoonAssemblyActivatorTests : XCTestCase {
    
    internal func test_activates() {
        
        let assembly = SwiftMiddleAgesAssembly()
        TyphoonAssemblyActivator.withAssembly(assembly).activate()
        
        let knight = assembly.basicKnight() as Knight
        println(knight.description())
        XCTAssertTrue(knight.isKindOfClass(Knight.self))
        
        
    }


}
