//
//  SettingsViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 04.12.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//
//  Данный класс представляет собой браузер)
//
import UIKit
import SwiftyJSON
class SettingsViewController: UIViewController, UISearchBarDelegate, UIWebViewDelegate {
    var url = URL(string: "https://github.com/login")
    @IBOutlet weak var webView: UIWebView!
    let searchBAR = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBAR.showsCancelButton = false
        searchBAR.placeholder = "Search"
        searchBAR.delegate = self
        searchBAR.text = "https://github.com/login"
        searchBAR.keyboardType = UIKeyboardType.URL
        self.navigationItem.titleView = searchBAR
        let request = URLRequest(url: url!)
        //let urlConnection = NSURLConnection(request: request, delegate: self)
        webView.loadRequest(request)
    }
    //
    //  Обновить страницу
    //
    @IBAction func refreshBtn(_ sender: Any) {
        webView.reload()
    }
    //
    //  Вернуться на предыдущую страницу
    //
    @IBAction func webBackBtn(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    //
    //  Вернуться к профилю
    //
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //
    //  В случае выхода из аккаунта пользователя, обнуляются все данные о нем.
    //
    @IBAction func extBtn(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "token")
        authDATA = JSON("")
        repoDATA = [String: String]()
        newsDATA = [[String: String]]()
        let AuthVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC")
        self.present(AuthVC!, animated: false)
    }
    //
    //  Произвести поиск
    //
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let url = URL(string: searchBAR.text!){
            webView.loadRequest(URLRequest(url: url))
            searchBar.text = ""
        } else{
            webView.reload()
        }
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
