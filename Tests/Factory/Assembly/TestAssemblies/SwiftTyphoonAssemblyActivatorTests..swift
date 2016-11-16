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
        
        let assembly = SwiftMiddleAgesAssembly().activate()
        
        let knight = assembly.basicKnight() as! Knight
        XCTAssertTrue(knight.isKind(of: Knight.self))
    }
    
    internal func test_injects_runtime_args() {
        
        let assembly = SwiftMiddleAgesAssembly().activate()
                
        let fort = Fort()
        if let knight = assembly.wanderingKnight(fort) as? Knight {
            XCTAssertTrue(knight.isKind(of: Knight.self))
            XCTAssertNotNil(knight.homeFort)
        } else {
            XCTFail("Cannot convert to Knight")
        }
        
    }


}
