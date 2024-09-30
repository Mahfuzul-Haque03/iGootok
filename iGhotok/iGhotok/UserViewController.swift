//
//  UserViewController.swift
//  iGhotok
//
//  Created by kuet on 7/11/21.
//  Copyright © 2021 kuet. All rights reserved.
//

import UIKit
import Firebase
class UserViewController: UIViewController {
    var userKey: String = ""
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userHeight: UILabel!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var education: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var religion: UILabel!
    @IBOutlet weak var contactNo: UILabel!
    @IBOutlet weak var fatherName: UILabel!
    @IBOutlet weak var fatherProf: UILabel!
    @IBOutlet weak var motherName: UILabel!
    @IBOutlet weak var motherProf: UILabel!
    @IBOutlet weak var SiblingNo: UILabel!
    @IBOutlet weak var presentAdd: UILabel!
    @IBOutlet weak var permAdd: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("userdata/\(userKey)").observe(.value, with:{(snapshot) in
            if snapshot.exists() {
                
                print(snapshot)
                if let value = snapshot.value{
                    let data = value as! [String:String]
                    func checkDB(key:String)->String{
                        if data.keys.contains(key) {
                            return data[key] ?? "-----" ;
                            
                        }
                        return "-----";
                    }
                    //there is data available
                    
                    print("\(data)")
                    guard let url = URL(string: data["dpurl"]!) else {return}
                    self.userImageView.load(url: url)
                    let age = "Age: " + data["age"]!
                        let height =  "Height: " + data["height"]!
                    
                    self.userAge.text = age
                    self.userHeight.text = height
                    self.userName.text =  data["fullname"]!
                    self.contactNo.text = checkDB(key: "contactno")
                    self.dob.text = checkDB(key: "dob")
                    self.education.text = checkDB(key: "education")
                    self.profession.text = checkDB(key: "profession")
                    self.religion.text = checkDB(key: "religion")
                    self.fatherName.text = "Father's Name: " + checkDB(key: "fathername")
                    self.fatherProf.text = "Father's Name: " + checkDB(key: "fatherprof")
                    self.motherName.text = "Mother's Name: " + checkDB(key: "mothername")
                    self.motherProf.text = "Mother's Name: " + checkDB(key: "motherprof")
                    self.SiblingNo.text = "Number of Siblings:" + checkDB(key: "siblingno")
                    self.permAdd.text = "Permanent Address:\n" +  checkDB(key: "permadd")
                    self.presentAdd.text = "Present Address:\n" + checkDB(key: "preadd")
                    
                    
                }else{
                    //there is no data available. snapshot.value is nil
                    print("No data available from snapshot.value!!!!")
                }
                
                
            } else {
                print("we don't have that, add it to the DB now")
            }
            // self.Name.text = name;
            
        })
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
