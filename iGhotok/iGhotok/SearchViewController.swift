//
//  SearchViewController.swift
//  iGhotok
//
//  Created by kuet on 7/11/21.
//  Copyright © 2021 kuet. All rights reserved.
//

import UIKit
import Firebase
var userKey = [String]()

var curUser:String = ""
class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var pq: [String] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pq.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is UserViewController {
            let vc = segue.destination as? UserViewController
            vc?.userKey = curUser
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sleep(2)
        tableView.delegate = self
        tableView.dataSource = self
        print("MY PQ")
        print(pq);
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("userdata").observe(.value, with:{(snapshot) in
            if snapshot.exists() {
                
                for a in ((snapshot.value as AnyObject).allKeys)!{
                    userKey.append(a as! String)
                }
                print(userKey)
                }else{
                    //there is no data available. snapshot.value is nil
                    print("No data available from snapshot.value!!!!")
                }
            // self.Name.text = name;
            
        })
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.cellView.layer.cornerRadius = cell.frame.height/4
         var ref: DatabaseReference!
         ref = Database.database().reference()
         ref.child("userdata/\(pq[indexPath.row])").observe(.value, with:{(snapshot) in
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
            var urlText = checkDB(key: "dpurl")
            if urlText == "-----" {
                cell.userPIc.image = UIImage(named: "dp1")
                
            }
            else {
                guard let url = URL(string: data["dpurl"]!) else {return}
                cell.userPIc.load(url: url)
            }
         cell.fullName.text = checkDB(key: "fullname")
         
         }else{
         //there is no data available. snapshot.value is nil
         print("No data available from snapshot.value!!!!")
         }
         
         
         } else {
         print("we don't have that, add it to the DB now")
         }
         // self.Name.text = name;
         
         })
       // cell.fullName.text = pq [indexPath.row]
        //        cell.userPIc.image = UIImage(named: "dp1")
        
        cell.userPIc.layer.cornerRadius = cell.userPIc.frame.height/4
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curUser = pq [ indexPath.row ]
        self.performSegue(withIdentifier: "showUser", sender: self)
        
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

