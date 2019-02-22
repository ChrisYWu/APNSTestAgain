//
//  ViewController.swift
//  APNSTestAgain
//
//  Created by Chris Wu on 1/18/19.
//  Copyright © 2019 KDP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func checkedTouched(_ sender: UIButton) {
        presentRefreshDialogue()
    }
    
    private func presentRefreshDialogue() {
        print("applicationIconBadgeNumber = \(UIApplication.shared.applicationIconBadgeNumber)")

        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            let alert = UIAlertController(
                title: "Notification Received",
                message: "Do you want to refresh for delivery updates?",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(
                title: "Refresh",
                style: UIAlertAction.Style.default,
                handler: { (action) in
                    //The Refershing Screen Code
            }))
            
            alert.addAction(UIAlertAction(
                title: "Ignore",
                style: UIAlertAction.Style.destructive,
                handler: { (action) in
                    UIApplication.shared.applicationIconBadgeNumber = 0
            }))
            
            alert.addAction(UIAlertAction(
                title: "Remind Me Later",
                style: UIAlertAction.Style.cancel))
            
            present(alert, animated: true)
        }
        
    }
}

