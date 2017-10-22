//
//  HomeViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 21.10.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
var list = ["": JSON("")]
class HomeViewController: UIViewController {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(token: UserDefaults.standard.string(forKey: "token")!)
        // Do any additional setup after loading the view.
    }
    func setTitle(title: String){
        self.title = title
    }
    func getData(token: String){
        let headers = [
            "Authorization" : "Basic " + token
        ]
        Alamofire.request("https://api.github.com/user", headers: headers).responseJSON{ response in
            list = JSON(response.result.value!).dictionary!
            //print(self.list)
            let UserData = JSON(response.result.value!)
            self.setTitle(title: UserData["login"].string!)
            self.parseAvatarImage(url: UserData["avatar_url"].string!)
            self.usernameLabel.text = UserData["name"].string!
        }
    }
    func parseAvatarImage(url: String){
        let imgURL: NSURL = NSURL(string: url)!
        let imgData = NSData(contentsOf: imgURL as URL)
        avatarImage.image = UIImage(data: imgData! as Data)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func exitBtnPressed(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "token")
        let AuthVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC")
        self.present(AuthVC!, animated: false)
    }
}
