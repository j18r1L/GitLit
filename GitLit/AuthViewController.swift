//
//  AuthViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 21.10.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
var authData = JSON("")
class AuthViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loginField: UITextField!
    @IBAction func loginBtnPressed(_ sender: Any) {
        if loginField.text! == "" || passField.text! == ""{
            infoLabel.text = "One of the fields is empty!"
        } else {
            let token = (((loginField.text! as String) + ":" + (passField.text! as String)).data(using: String.Encoding.utf8)?.base64EncodedString())!
            doLogIn(token: token)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.string(forKey: "token") != nil){
            doLogIn(token: UserDefaults.standard.string(forKey: "token")!)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func doLogIn(token: String){
        let headers = [
            "Authorization" : "Basic " + token
        ]
        Alamofire.request("https://api.github.com/user", headers: headers).responseJSON{ response in
            let jsonResp = JSON(response.result.value!)
            if jsonResp["message"] == "Bad credentials"{
                self.infoLabel.text = "Incorrect username or password."
            } else {
                authData = jsonResp
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC")
                UserDefaults.standard.set(token, forKey: "token")
                self.present(homeVC!, animated: false)
            }
        }
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
