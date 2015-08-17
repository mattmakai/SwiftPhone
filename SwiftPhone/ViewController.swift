//
//  ViewController.swift
//  SwiftPhone
//
//  Created by Matthew Makai on 8/12/15.
//  Copyright (c) 2015 Matt Makai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var phone:Phone = Phone()
    
    @IBOutlet var btnAnswer: UIButton!
    @IBOutlet var btnReject: UIButton!
    @IBOutlet var btnIgnore: UIButton!
    
    @IBAction func btnAnswer(sender: AnyObject) {
        self.phone.acceptConnection()
    }
    
    @IBAction func btnReject(sender: AnyObject) {
        self.phone.rejectConnection()
    }
    
    @IBAction func btnIgnore(sender: AnyObject) {
        self.phone.ignoreConnection()
    }
    
    
    @IBAction func btnCall(sender: AnyObject) {
        self.phone.connectWithParams();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:Selector("pendingIncomingConnectionReceived:"),
            name:"PendingIncomingConnectionReceived", object:nil)
        
        self.phone.login();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pendingIncomingConnectionReceived(notification:NSNotification) {
        if UIApplication.sharedApplication().applicationState != UIApplicationState.Active {
            var notification:UILocalNotification = UILocalNotification();
            notification.alertBody = "Incoming Call"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification);
        }
        
        self.btnAnswer.enabled = true
        self.btnReject.enabled = true
        self.btnIgnore.enabled = true
    }

}

