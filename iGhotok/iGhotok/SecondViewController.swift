//
//  SecondViewController.swift
//  iGhotok
//
//  Created by kuet on 28/10/21.
//  Copyright © 2021 kuet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import DropDown
struct Profession:Decodable {
    let id:String
    let name:String
}
struct Professions:Decodable{
    let occupations:[Profession]
}
class SecondViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rePassword: UITextField!
    @IBOutlet weak var checker: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var heightLabel: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    var ref = Database.database().reference()
    // Get a reference to the storage service using the default Firebase App
    @IBOutlet weak var ageDropView: UIView!
    @IBOutlet weak var professionDropView: UIView!
    @IBOutlet weak var genderDropView: UIView!
    let ageDropDown = DropDown()
    let professionDropDown = DropDown()
    let genderDropDown = DropDown()
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var imageDP: UIImageView!
    @IBAction func uploadDP(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageDP.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        saveData();
    }
    @IBAction func reg_button(_ sender: UIButton) {
       /* let Age = age.text;
        let Profession = profession.text;
        let Name = fullname.text;
        let Phone = contact_no.text;
        let Address = address.text;
        let Gender = gender.text;
        let Username = username.text;
        let Password = password.text;
        let rePassword = confirm_password.text;
        var ok:Bool = true;
        for X in [Age,Profession,Name,Phone,Address,Gender,Username,Password,rePassword]{
            if(X == ""){
                ok = false;
                
            }
        }
        if(!ok){
            checker.isHidden = false;
            
        }else{
            Auth.auth().createUser(withEmail: Username ?? "Defu", password: Password ?? "pass"){(result,err) in
                
                if err != nil{
                    self.checker.isHidden = false;
                    self.checker.text = err as? String;
                    
                }else{
                    let id = result?.user.uid;
                    let dict = ["Name":Name,
                                "Age":Age,
                                "Profession":Profession,
                                "Phone":Phone,
                                "Gender":Gender,
                                "Address":Address,
                                "Username":Username,
                                "Password":Password]
                    self.ref.child("userdata").child(id!).setValue(dict)
                     self.performSegue(withIdentifier: "homePage", sender: self)
                }
                
            }
           
            
        }*/
        
    }
    
    func saveData(){
        self.uploadImage(self.imageDP.image!){
            url in
            let fullnameText = self.fullName.text;
            let ageText = self.ageLabel.text
            let genderText = self.genderLabel.text
            let professionText = self.professionLabel.text
            let emailText = self.email.text
            let passwordText = self.password.text
            let repasswordText = self.rePassword.text
            let heightText = self.heightLabel.text
            var ok:Bool = true
            for X in [ fullnameText, emailText , passwordText , repasswordText ]{
                if X == "" {
                    ok = false
                }
            }
            if (ok == false){
                self.signUpButton.backgroundColor = UIColor.red;
            }else{
                Auth.auth().createUser(withEmail: emailText ?? "", password:passwordText ?? ""){(result,err) in
                    if err != nil{
                        print(err as! String)
                    }else{
                        let id = result?.user.uid;
                        let dict = [ "fullname":fullnameText!,
                                     "age":ageText!,
                                     "height":heightText!,
                                     "gender":genderText!,
                                     "profession": professionText!,
                                     "dpurl":url?.absoluteString as Any] as [String : Any]
                        print(dict)
                        self.ref.child("userdata").child(id!).setValue(dict)
                        print("FIN")
                        self.performSegue(withIdentifier: "homePage", sender: self)
                        
                    }
                }
                
            }
            
        }
    }
    @objc func showAge(tapGesture: UITapGestureRecognizer){
        self.ageDropDown.show();
        self.ageDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.ageLabel.text = self.ageDropDown.dataSource[index]
        }
    }
    @objc func showProfession(tapGesture: UITapGestureRecognizer){
        self.professionDropDown.show();
        self.professionDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.professionLabel.text = self.professionDropDown.dataSource[index]
        }
    }
    @objc func showGender(tapGesture: UITapGestureRecognizer){
        self.genderDropDown.show();
        self.genderDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.genderLabel.text = self.genderDropDown.dataSource[index]
        }
    }
    override func viewDidLoad() {
        //checker.isHidden = true;
        super.viewDidLoad()
        
        // The view to which the drop down will appear on
        ageDropDown.anchorView = view // UIView or UIBarButtonItem
        professionDropDown.anchorView = professionDropView
        // The list of items to display. Can be changed dynamically
        var ageArray = [String] ()
        var professionArray = [String]()
        for i in 18...60 {
            
            ageArray.append(String(i));
        }
        ageDropDown.dataSource = ageArray
        genderDropDown.dataSource = ["Male","Female"]
        
        let ageTapGesture = UITapGestureRecognizer()
        ageTapGesture.addTarget(self, action: #selector(SecondViewController.showAge(tapGesture:)))
        
        let professionTapGesture = UITapGestureRecognizer()
        professionTapGesture.addTarget(self, action: #selector(SecondViewController.showProfession(tapGesture:)))
        
        let genderTapGesture = UITapGestureRecognizer()
        genderTapGesture.addTarget(self, action: #selector(SecondViewController.showGender(tapGesture:)))
        
        
        ageDropView.isUserInteractionEnabled = true;
        ageDropView.addGestureRecognizer(ageTapGesture)
        
        professionDropView.isUserInteractionEnabled = true;
        professionDropView.addGestureRecognizer(professionTapGesture)
        
        genderDropView.isUserInteractionEnabled = true;
        genderDropView.addGestureRecognizer(genderTapGesture)
        
        let urlString = "https://mocki.io/v1/913e650b-afb6-45a1-bc9e-656543f76f11"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url){(data,res,err) in
            guard let pdata = data else {return}
            do{
                let prufs = try JSONDecoder().decode(Professions.self,from: pdata)
                for x in prufs.occupations{
                    professionArray.append(x.name)
                }
                self.professionDropDown.dataSource = professionArray
                
            }catch _{
                print("ERROR" )
            }
        }.resume()
        
        
        
        


        // Do any additional setup after loading the view.
    }
    
}

extension SecondViewController{
    func uploadImage(_ image: UIImage,completion: @escaping (_ url: URL? )->()){
        let imageName = email.text ?? "def" + ".png"
        let storageRef = Storage.storage().reference().child(imageName)
        let imgData = imageDP.image?.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metaData){(metaData, err) in
            if err == nil {
                print("Sucess")
                storageRef.downloadURL(completion: {
                    (url, err) in completion(url!)}
                )
            }else {
                print("Error in save image")
                completion(nil)
            }
        }
    }
}
