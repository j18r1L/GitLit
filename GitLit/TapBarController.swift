//
//  TapBarController.swift
//  GitLit
//
//  Created by Emil Astanov on 08.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//
//  Данный класс отображает тапбар меню.
//
import UIKit
import SwiftyJSON
class TapBarController: UITabBarController {
    //
    //  В качетсве заголовка окна устанавливается логин пользователя.
    //
    @IBOutlet weak var tapbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isWebConnect {
            self.title = authDATA["login"].string!
        } else {
            self.title = "Connection error."
            tapbar.isHidden = true
        }
        
    }
}
