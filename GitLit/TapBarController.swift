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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = authDATA["login"].string!
    }
}
