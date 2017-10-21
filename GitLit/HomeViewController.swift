//
//  HomeViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 21.10.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = authData["login"].string
        parseAvatarImage(url: authData["avatar_url"].string!)
        usernameLabel.text = authData["name"].string
        print(authData)
        // Do any additional setup after loading the view.
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
