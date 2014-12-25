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

import UIKit
import XCTest
import Typhoon
import TyphoonFrameworkSwiftExample

class TyphoonFrameworkSwiftExampleTests: XCTestCase {
        
    func testBasicInjectionViaDynamicFramework() {
        
        let factory = TyphoonBlockComponentFactory(assemblies: [
            Assembly()
        ])
        
        let storyboard = TyphoonStoryboard(name: "Main", factory: factory, bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("viewController") as ViewController
        
        XCTAssertEqual(controller.foo!, "bar", "injected foo should equal bar")
    }
}
