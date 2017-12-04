//
//  SettingsViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 04.12.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import SwiftyJSON
class SettingsViewController: UIViewController, UISearchBarDelegate, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://github.com/login")
        let request = URLRequest(url: url!)
        searchBar.text = "https://github.com/login"
        //let urlConnection = NSURLConnection(request: request, delegate: self)
        webView.loadRequest(request)
    }

    //
    //  В случае выхода из аккаунта пользователя, обнуляются все данные о нем.
    //
    @IBAction func backBtn(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    @IBAction func extBtn(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "token")
        authDATA = JSON("")
        repoDATA = [String: String]()
        newsDATA = [[String: String]]()
        let AuthVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC")
        self.present(AuthVC!, animated: false)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let url = URL(string: searchBar.text!){
            webView.loadRequest(URLRequest(url: url))
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
