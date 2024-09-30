//
//  ProfileViewController.swift
//  iGhotok
//
//  Created by kuet on 28/10/21.
//  Copyright © 2021 kuet. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var Age: UILabel!
    @IBOutlet weak var DOBTF: UITextField!
    @IBOutlet weak var eduTF: UITextField!
    @IBOutlet weak var professionTF: UITextField!
    @IBOutlet weak var contactTF: UITextField!
    @IBOutlet weak var religionTF: UITextField!
    @IBOutlet weak var fatherNameTF: UITextField!
    @IBOutlet weak var fatherProfTF: UITextField!
    @IBOutlet weak var motherTF: UITextField!
    @IBOutlet weak var motherProfTF: UITextField!
    @IBOutlet weak var siblingTF: UITextField!
    @IBOutlet weak var permAddTF: UITextField!
    @IBOutlet weak var preAddTF: UITextField!
    @IBAction func updateButton(_ sender: UIButton) {
    }
    @IBAction func logOutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        self.present(initialViewController, animated: true)
    }

    @IBAction func updateDB(_ sender: UIButton) {
        let dict = [
            "fullname":self.Name.text,
            "contactno":self.contactTF.text,
            "dob":self.DOBTF.text,
            "education":self.eduTF.text,
            "profession":self.professionTF.text,
            "religion":self.religionTF.text,
            "fathername":self.fatherNameTF.text,
            "fatherprof":self.fatherProfTF.text,
            "mothername":self.motherTF.text,
            "motherprof":self.motherProfTF.text,
            "siblingno":self.siblingTF.text,
            "permadd":self.permAddTF.text,
            "preadd":self.preAddTF.text
        ]
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            _ = Database.database().reference().root.child("userdata").child(uid).updateChildValues(dict as [AnyHashable : Any])
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/8
        profileImage.clipsToBounds = true
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            let email = user.email
            print(email!)
            ref.child("userdata/\(uid)").observe(.value, with:{(snapshot) in
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
                        self.profileImage.load(url: url)
                        let ageHeight = "Age: " + data["age"]! + "   Height: " + data["height"]!
                        self.Age.text = ageHeight
                        self.Name.text = data["fullname"]!
                        self.contactTF.text = checkDB(key: "contactno")
                        self.DOBTF.text = checkDB(key: "dob")
                        self.eduTF.text = checkDB(key: "education")
                        self.professionTF.text = checkDB(key: "profession")
                        self.religionTF.text = checkDB(key: "religion")
                        self.fatherNameTF.text = checkDB(key: "fathername")
                        self.fatherProfTF.text = checkDB(key: "fatherprof")
                        self.motherTF.text = checkDB(key: "mothername")
                        self.motherProfTF.text = checkDB(key: "motherprof")
                        self.siblingTF.text = checkDB(key: "siblingno")
                        self.permAddTF.text = checkDB(key: "permadd")
                        self.preAddTF.text = checkDB(key: "preadd")
                        
                        
                    }else{
                        //there is no data available. snapshot.value is nil
                        print("No data available from snapshot.value!!!!")
                    }
                    
                   
                } else {
                    print("we don't have that, add it to the DB now")
                }
               // self.Name.text = name;
                
            })
            // ...
        }
        
        
        
        

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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
