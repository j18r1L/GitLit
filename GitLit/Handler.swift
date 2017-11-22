//
//  Handler.swift
//  GitLit
//
//  Created by Emil Astanov on 02.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//
//  Данный класс подгружает, данные пльзователя и передает их дальше.
//
import UIKit
import Alamofire
import SwiftyJSON
var authDATA = JSON("")
var repoDATA = [String: String]()
var newsDATA = [[String: String]]()
class Handler: UIViewController {
    @IBOutlet weak var previewGif: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        userData()
    }
    //
    //  Данная функция записывает основные данные об авторезированном пользователе в глобальную
    //  переменную и вызывает функцию repoDATA(login).
    //
    func userData(){
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        Alamofire.request("https://api.github.com/user", headers: headers).responseJSON{(response) -> Void in
            authDATA = JSON(response.result.value!)
            self.repoData(login: authDATA["login"].string!)
        }
    }
    //
    //  Данная функция записывает данные о репозитории пользователя в глобольную переменную
    //  и вызывает функцию newsData(login).
    //
    func repoData(login: String){
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        Alamofire.request("https://api.github.com/users/" + login + "/repos", headers: headers).responseJSON{(response) -> Void in
            let json = JSON(response.result.value!)
            for index in 0...(json.count-1){
                repoDATA[json[index]["full_name"].string!] = json[index]["url"].string!
            }
            self.newsData(login: login)
        }
    }
    //
    //  Данная функция загружает данные о последних 7 активностей подписок пользователя
    //  (просто 7 проще всего обработать)), и переводит на Home контроллер.
    //
    func newsData(login: String){
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        Alamofire.request("https://api.github.com/users/" + login + "/following", headers: headers).responseJSON{(response) -> Void in
            let json = JSON(response.result.value!)
            var followers = [String]()
            for index in 0...(json.count - 1){
                followers.append(json[index]["login"].string!)
            }
            for user in followers{
                Alamofire.request("https://api.github.com/users/"+user+"/events", headers: headers).responseJSON{(response) -> Void in
                    for ind in 0...7{
                        let json = JSON(response.result.value!)[ind]
                        var time = json["created_at"].string!
                        time = time[..<time.index(time.startIndex, offsetBy: 10)] + " " + time[time.index(time.startIndex, offsetBy: 11) ..< time.index(time.endIndex, offsetBy: -1)]
                        print(json)
                        if json["payload"]["commits"][0]["message"].string != nil && json["payload"]["action"].string != nil{
                            newsDATA.append([
                                "name": user,
                                "repo": json["repo"]["name"].string!,
                                "commit": json["payload"]["commits"][0]["message"].string!,
                                "avatar_url": json["actor"]["avatar_url"].string!,
                                "action": json["payload"]["action"].string!,
                                "time": time
                                ])
                        } else if json["payload"]["commits"][0]["message"].string != nil{
                            newsDATA.append([
                                "name": user,
                                "repo": json["repo"]["name"].string!,
                                "commit": json["payload"]["commits"][0]["message"].string!,
                                "avatar_url": json["actor"]["avatar_url"].string!,
                                "action": "",
                                "time": time
                                ])
                        } else if json["payload"]["action"].string != nil{
                            newsDATA.append([
                                "name": user,
                                "repo": json["repo"]["name"].string!,
                                "commit": "",
                                "avatar_url": json["actor"]["avatar_url"].string!,
                                "action": json["payload"]["action"].string!,
                                "time": time
                                ])
                        }
                    }
                }
            }
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC")
            self.present(homeVC!, animated: false)
        }
    }
}
