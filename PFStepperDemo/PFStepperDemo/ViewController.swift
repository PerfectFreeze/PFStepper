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
        let stepper = PFStepper(frame: CGRect(x: (view.bounds.width - 80) / 2, y: (view.bounds.height - 80) / 2, width: 80, height: 80))
        view.addSubview(stepper)
        view.backgroundColor = UIColor.lightGray
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

