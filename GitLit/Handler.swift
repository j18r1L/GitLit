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
var followers = [String]()
var followersList = [String: String]()
var isWebConnect = true
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
        if NetworkReachabilityManager()!.isReachable{
            let headers = [
                "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
            ]
            Alamofire.request("https://api.github.com/user", headers: headers).responseJSON{(response) -> Void in
                authDATA = JSON(response.result.value!)
                self.repoData(login: authDATA["login"].string!)
            }
        } else {
            Alamofire.request("https://").responseJSON{resonse in
                isWebConnect = false
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "OfflineFile")
                isProfileFiles = true
                self.getOfflineData()
                self.present(homeVC!, animated: false)
            }
        }
    }
    
    func getOfflineData(){

        let fileManager = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            for file in files{
                var isDir : ObjCBool = false
                if fileManager.fileExists(atPath: path + "/" + file, isDirectory:&isDir) {
                    if isDir.boolValue {
                        filehierarchy.append(File(type: .dir, name: file, url: path + "/" + file))
                    } else {
                        let ext = ((path+"/"+file) as NSString).pathExtension
                        do {
                            try fileManager.removeItem(atPath: path + "/" + file)
                        }
                        catch let error as NSError {
                            print("Ooops! Something went wrong: \(error)")
                        }
                        if ext == "png" || ext == "jpg" || ext  == "bmp" || ext == "tif" || ext == "gif" || ext == "PNG" || ext == "JPG" || ext  == "BMP" || ext == "TIF" || ext == "GIF" || ext == "jpeg" || ext == "JPEG" || ext == "tiff" || ext == "TIFF"{
                            filehierarchy.append(File(type: .img, name: file, url: path + "/" + file))
                        } else {
                            filehierarchy.append(File(type: .file, name: file, url: path + "/" + file))
                        }
                    }
                } else {
                    filehierarchy.append(File(type: .file, name: file, url: path + "/" + file))
                }
            }
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
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
            if response.result.value != nil{
                for index in 0...(json.count-1){
                    repoDATA[json[index]["full_name"].string!] = json[index]["url"].string!
                }
                Alamofire.request("https://api.github.com/users/" + login + "/subscriptions", headers: headers).responseJSON{ response in
                    let json = JSON(response.result.value!)
                    for index in 0..<json.count{
                        repoDATA[json[index]["full_name"].string!] = json[index]["url"].string!
                    }
                    UserDefaults.standard.set(repoDATA, forKey: "repoDATA")
                    self.newsData(login: login)
                }
            } else {
                isWebConnect = false
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "OfflineFile")
                isProfileFiles = true
                self.getOfflineData()
                
                self.present(homeVC!, animated: false)
            }
        }
    }
    //
    //  Данная функция загружает данные о активностях подписок пользователя.
    //
    func newsData(login: String){
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        Alamofire.request("https://api.github.com/users/" + login + "/following", headers: headers).responseJSON{(response) -> Void in
            let json = JSON(response.result.value!)
            for index in 0..<json.count{
                followers.append(json[index]["login"].string!)
                followersList[json[index]["login"].string!] = json[index]["avatar_url"].string!
            }
            for user in followers{
                Alamofire.request("https://api.github.com/users/"+user+"/events", headers: headers).responseJSON{(response) -> Void in
                    let userActivity = JSON(response.result.value!)
                    for ind in 0..<userActivity.count{
                        let json = userActivity[ind]
                        var time = json["created_at"].string!
                        time = time[..<time.index(time.startIndex, offsetBy: 10)] + " " + time[time.index(time.startIndex, offsetBy: 11) ..< time.index(time.endIndex, offsetBy: -1)]
                        //print(json)
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
