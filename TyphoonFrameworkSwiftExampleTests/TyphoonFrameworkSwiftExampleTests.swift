//
//  TyphoonFrameworkSwiftExampleTests.swift
//  TyphoonFrameworkSwiftExampleTests
//
//  Created by mike.owens on 12/8/14.
//  Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

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
