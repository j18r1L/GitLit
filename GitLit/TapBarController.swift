//
//  TapBarController.swift
//  GitLit
//
//  Created by Emil Astanov on 08.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import SwiftyJSON
class TapBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = authDATA["login"].string!
    }
    @IBAction func extBtnPressed(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "token")
        authDATA = JSON("")
        repoDATA = [String: String]()
        newsDATA = [[String: String]]()
        let AuthVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC")
        self.present(AuthVC!, animated: false)
    }
}
