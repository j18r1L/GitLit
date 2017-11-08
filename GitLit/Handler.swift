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
var newsDATA = [[String: String]]()
class Handler: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        repoData()
        userData()
        newsData()
        
        sleep(UInt32(0.4))
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
    func newsData(){
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        Alamofire.request("https://api.github.com/users/emilastanov/following", headers: headers).responseJSON{(response) -> Void in
            let json = JSON(response.result.value!)
            var followers = [String]()
            for index in 0...(json.count - 1){
                followers.append(json[index]["login"].string!)
            }
            for user in followers{
                Alamofire.request("https://api.github.com/users/"+user+"/events", headers: headers).responseJSON{(response) -> Void in
                    for ind in 0...3{
                        let json = JSON(response.result.value!)[ind]
                        var time = json["created_at"].string!
                        time = time[..<time.index(time.startIndex, offsetBy: 10)] + " " + time[time.index(time.startIndex, offsetBy: 11) ..< time.index(time.endIndex, offsetBy: -1)]
                        if json["payload"]["commits"][0]["message"].string != nil{
                            newsDATA.append([
                                "name": user,
                                "repo": json["repo"]["name"].string!,
                                "commit": json["payload"]["commits"][0]["message"].string!,
                                "avatar_url": json["actor"]["avatar_url"].string!,
                                "time": time
                                ])
                        } else {
                            newsDATA.append([
                                "name": user,
                                "repo": json["repo"]["name"].string!,
                                "commit": "",
                                "avatar_url": json["actor"]["avatar_url"].string!,
                                "time": time
                                ])
                        }
                    }
                }
            }
        }
    }
}
