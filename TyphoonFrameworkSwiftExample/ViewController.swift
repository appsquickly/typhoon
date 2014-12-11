//
//  ViewController.swift
//  TyphoonFrameworkSwiftExample
//
//  Created by mike.owens on 12/8/14.
//  Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

import UIKit

public class ViewController: UIViewController {

    public var foo: String?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("Worked! \(foo)")
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

