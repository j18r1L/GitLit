//
//  ViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 22.10.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "AuthVC"))!, animated: false, completion: nil)
        //checkAuth()
    }
    func checkAuth(){
        if UserDefaults.standard.string(forKey: "token") != nil{
            print("User already login")
            doLogIn(token: UserDefaults.standard.string(forKey: "token")!)
        } else {
            print("Undefined user")
            self.present((self.storyboard?.instantiateViewController(withIdentifier: "AuthVC"))!, animated: false, completion: nil)
        }
    }
    func doLogIn(token: String){
        let headers = [
            "Authorization" : "Basic " + token
        ]
        Alamofire.request("https://api.github.com/user", headers: headers).responseJSON{ response in
            let jsonResp = JSON(response.result.value!)
            if jsonResp["message"] == "Bad credentials"{
                self.present((self.storyboard?.instantiateViewController(withIdentifier: "AuthVC"))!, animated: false, completion: nil)
            } else {
                self.present((self.storyboard?.instantiateViewController(withIdentifier: "homeVC"))!, animated: false, completion: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
