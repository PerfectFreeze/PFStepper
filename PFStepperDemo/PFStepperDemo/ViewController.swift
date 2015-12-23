//
//  ViewController.swift
//  PFStepperDemo
//
//  Created by Cee on 23/12/2015.
//  Copyright © 2015 Cee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let stepper = PFStepper(frame: CGRectMake((view.bounds.width - 80) / 2, (view.bounds.height - 80) / 2, 80, 80))
        view.addSubview(stepper)
        view.backgroundColor = UIColor.lightGrayColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

