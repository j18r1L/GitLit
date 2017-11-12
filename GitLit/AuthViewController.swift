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
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "Handler")
                UserDefaults.standard.set(token, forKey: "token")
                self.present(homeVC!, animated: false)
            }
        }
    }
    @IBAction func tapedAnyWay(_ sender: Any) {
        view.endEditing(true)
    }
}
