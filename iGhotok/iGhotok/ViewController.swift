//
//  ViewController.swift
//  iGhotok
//
//  Created by kuet on 26/10/21.
//  Copyright © 2021 kuet. All rights reserved.
//

import UIKit
import Firebase;
class ViewController: UIViewController {

    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text0: UITextField!
    @IBOutlet weak var checker: UILabel!
    @IBAction func button1(_ sender: UIButton) {
        let uname = "test@gmail.com";//text0.text
        let pass = "testcase";//text1.text
        
        Auth.auth().signIn(withEmail: uname, password: pass){(result,err) in
                
                if err != nil{
                    self.checker.isHidden = false;
                    
                }else{
                    self.performSegue(withIdentifier: "homePage", sender: self)
                }
                
            }
        
     
        
        
    }
    override func viewDidLoad() {
        checker.isHidden = true;
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

