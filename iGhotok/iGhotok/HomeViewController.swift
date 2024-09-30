//
//  HomeViewController.swift
//  iGhotok
//
//  Created by kuet on 28/10/21.
//  Copyright © 2021 kuet. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    var send: [String] = []
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is SearchViewController {
            let vc = segue.destination as? SearchViewController
            vc?.pq = send
            print(send)
          /*  */
        }
    }
    @IBOutlet weak var district: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var profession: UITextField!
    @IBOutlet weak var religion: UITextField!
    
    @IBAction func SearchMatch(_ sender: UIButton) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("userdata").observe(.value, with:{(snapshot) in
            if snapshot.exists() {
                
                for a in ((snapshot.value as AnyObject).allKeys)!{
                    self.send.append(a as! String)
                    print(a)
                }
                self.performSegue(withIdentifier: "SearchResult", sender: self)
            }else{
                //there is no data available. snapshot.value is nil
                print("No data available from snapshot.value!!!!")
            }
            // self.Name.text = name;
            
        })
       // sleep(5)
        
    }
    override func viewDidLoad() {
       
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
