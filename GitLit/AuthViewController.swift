//
//  AuthViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 21.10.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//
//  Данный класс отображает окно авторизации.
//
import UIKit
import SwiftyJSON
import Alamofire
class AuthViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loginField: UITextField!
    //
    //  В случае если кнопка login нажата, а одно из полей не заполнено,
    //  label-y присваивается соответсвующий текст.
    //  Если все поля заполнены формируется токен, который состоит из логина и пароля,
    //  разделенных двоиточием. Токен кодируется в формат base64, так хочет github.
    //
    @IBAction func loginBtnPressed(_ sender: Any) {
        if loginField.text! == "" || passField.text! == ""{
            infoLabel.text = "One of the fields is empty!"
        } else {
            let token = (((loginField.text! as String) + ":" + (passField.text! as String)).data(using: String.Encoding.utf8)?.base64EncodedString())!
            doLogIn(token: token)
        }
    }
    //
    //  Функция  doLogIn(token) отправляет запрос на сервер используя библеотеки: Alamofire, для отправки и  SwiftyJSON,
    //  для обработки ответа. В случае корректных данных, ответ записывается и отбражается Home Controller,
    //  иначе label-y присваивается соответсвующий текст.
    //
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
    //
    //  Ести каснуться экрана в любом месте при включенной клавиатуре, она спрячется.
    //
    @IBAction func tapedAnyWay(_ sender: Any) {
        view.endEditing(true)
    }
}
