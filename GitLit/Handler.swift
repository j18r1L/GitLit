//
//  Handler.swift
//  GitLit
//
//  Created by Emil Astanov on 02.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
var authDATA = JSON("")
var repoDATA = [String: String]()
class Handler: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        repoData()
        userData()
        sleep(UInt32(0.3))
        // Do any additional setup after loading the view.
    }
    func userData(){
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        Alamofire.request("https://api.github.com/user", headers: headers).responseJSON{(response) -> Void in
            authDATA = JSON(response.result.value!)
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC")
            self.present(homeVC!, animated: false)
        }
    }
    func repoData(){
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        Alamofire.request("https://api.github.com/users/emilastanov/repos", headers: headers).responseJSON{(response) -> Void in
            let json = JSON(response.result.value!)
            for index in 0...(json.count-1){
                repoDATA[json[index]["full_name"].string!] = json[index]["html_url"].string! //replace "html_url" "url"
            }
        }
    }
}
