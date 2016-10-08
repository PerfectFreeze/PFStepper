//
//  PFStepper.swift
//  PFStepper
//
//  Created by Cee on 22/12/2015.
//  Copyright © 2015 Cee. All rights reserved.
//

import UIKit

public class PFStepper: UIControl {
    public var value: Double = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
            
            let isInteger = floor(value) == value
            
            if showIntegerIfDoubleIsInteger && isInteger {
                topButton.setTitle(String(stringInterpolationSegment: Int(value)), forState: .Normal)
                bottomButton.setTitle(String(stringInterpolationSegment: Int(value + stepValue)), forState: .Normal)
            } else {
                topButton.setTitle(String(stringInterpolationSegment: value), forState: .Normal)
                bottomButton.setTitle(String(stringInterpolationSegment: value + stepValue), forState: .Normal)
            }
            
            if oldValue != value {
                sendActionsForControlEvents(.ValueChanged)
            }
            if value <= minimumValue {
                topButton.setTitle("", forState: .Normal)
                topButton.backgroundColor = UIColor.whiteColor()
            } else {
                topButton.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
                topButton.alpha = 0.5
            }
            if value >= maximumValue {
                bottomButton.setTitle("", forState: .Normal)
            } else {
            }
        }
    }
    public var minimumValue: Double = 0
    public var maximumValue: Double = 24
    public var stepValue: Double = 1
    public var autorepeat: Bool = true
    public var showIntegerIfDoubleIsInteger: Bool = true
    public var topButtonText: String = ""
    public var bottomButtonText: String = "1"
    public var buttonsTextColor: UIColor =  UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    public var buttonsBackgroundColor: UIColor = UIColor.whiteColor()
    public var buttonsFont = UIFont(name: "AvenirNext-Bold", size: 20.0)!
    lazy var topButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.topButtonText, forState: .Normal)
        button.setTitleColor(self.buttonsTextColor, forState: .Normal)
        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont
//        button.contentHorizontalAlignment = .Left
//        button.contentVerticalAlignment = .Top
//        button.titleEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0)
        button.addTarget(self, action: #selector(PFStepper.topButtonTouchDown(_:)), forControlEvents: .TouchDown)
        button.addTarget(self, action: #selector(PFStepper.buttonTouchUp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button.addTarget(self, action: #selector(PFStepper.buttonTouchUp(_:)), forControlEvents: UIControlEvents.TouchUpOutside)
        return button
    }()
    lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.bottomButtonText, forState: .Normal)
        button.setTitleColor(self.buttonsTextColor, forState: .Normal)
        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont
        button.addTarget(self, action: #selector(PFStepper.bottomButtonTouchDown(_:)), forControlEvents: .TouchDown)
        button.addTarget(self, action: #selector(PFStepper.buttonTouchUp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button.addTarget(self, action: #selector(PFStepper.buttonTouchUp(_:)), forControlEvents: UIControlEvents.TouchUpOutside)
        return button
    }()
    
    enum StepperState {
        case Stable, ShouldIncrease, ShouldDecrease
    }
    
    var stepperState = StepperState.Stable {
        didSet {
            if stepperState != .Stable {
                updateValue()
                if autorepeat {
                    scheduleTimer()
                }
            }
        }
    }
    
    let limitHitAnimationDuration = NSTimeInterval(0.1)
    var timer: NSTimer?
    
    /** When UIStepper reaches its top speed, it alters the value with a time interval of ~0.05 sec.
     The user pressing and holding on the stepper repeatedly:
     - First 2.5 sec, the stepper changes the value every 0.5 sec.
     - For the next 1.5 sec, it changes the value every 0.1 sec.
     - Then, every 0.05 sec.
     */
    let timerInterval = NSTimeInterval(0.05)
    
    /// Check the handleTimerFire: function. While it is counting the number of fires, it decreases the mod value so that the value is altered more frequently.
    var timerFireCount = 0
    var timerFireCountModulo: Int {
        if timerFireCount > 80 {
            return 1 // 0.05 sec * 1 = 0.05 sec
        } else if timerFireCount > 50 {
            return 2 // 0.05 sec * 2 = 0.1 sec
        } else {
            return 10 // 0.05 sec * 10 = 0.5 sec
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        addSubview(topButton)
        addSubview(bottomButton)
        
        backgroundColor = buttonsBackgroundColor
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PFStepper.reset), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    public override func layoutSubviews() {
        let buttonWidth = bounds.size.width
        
        topButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: bounds.size.height / 2)
        bottomButton.frame = CGRect(x: 0, y: bounds.size.height / 2, width: buttonWidth, height: bounds.size.height / 2)
    }
    
    func updateValue() {
        if stepperState == .ShouldIncrease {
            value += stepValue
        } else if stepperState == .ShouldDecrease {
            value -= stepValue
        }
    }
    
    deinit {
        resetTimer()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: - Button Events
extension PFStepper {
    func reset() {
        stepperState = .Stable
        resetTimer()
        
        topButton.enabled = true
        bottomButton.enabled = true
    }
    
    func topButtonTouchDown(button: UIButton) {
        bottomButton.enabled = false
        resetTimer()
        
        if value == minimumValue {
            button.setTitle("", forState: .Normal)
        } else {
            stepperState = .ShouldDecrease
        }
        
    }
    
    func bottomButtonTouchDown(button: UIButton) {
        topButton.enabled = false
        resetTimer()
        
        if value == maximumValue {
            button.setTitle("", forState: .Normal)
        } else {
            stepperState = .ShouldIncrease
        }
    }
    
    func buttonTouchUp(button: UIButton) {
        reset()
    }
}

// MARK: - Timer
extension PFStepper {
    func handleTimerFire(timer: NSTimer) {
        timerFireCount += 1
        
        if timerFireCount % timerFireCountModulo == 0 {
            updateValue()
        }
    }
    
    func scheduleTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: #selector(PFStepper.handleTimerFire(_:)), userInfo: nil, repeats: true)
    }
    
    func resetTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
            timerFireCount = 0
        }
    }
}
