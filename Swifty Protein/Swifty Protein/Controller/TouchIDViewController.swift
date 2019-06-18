//
//  TouchIDViewController.swift
//  Swifty Protein
//
//  Created by Morgane on 18/06/2019.
//  Copyright © 2019 Morgane DUBUS. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class TouchIDViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginWithTouchID(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login to Swifty Protein", reply: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "TouchIDToProteinsList", sender: self)
                    }
                }
                else {
                    alert(view: self, message: "Authentication failed")
                }
            })
        }
        else {
            alert(view: self, message: "Touch ID is not available on your device")
        }
    }
    
}
