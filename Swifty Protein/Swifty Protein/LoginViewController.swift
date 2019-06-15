//
//  LoginViewController.swift
//  Swifty Protein
//
//  Created by Morgane DUBUS on 6/14/19.
//  Copyright © 2019 Morgane DUBUS. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController  {
    
    @IBOutlet weak var _login: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submit(_ sender: Any) {
        if (_login.text?.isEmpty == false && _password.text?.isEmpty == false) {
            print("logged !")
            // Segue to ligand's list
        }
        else {
            // Error : Need login and password
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

