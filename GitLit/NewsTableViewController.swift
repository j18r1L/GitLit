//
//  NewsTableViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 08.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//
//  Данный класс отображает активность подписок.
//
import UIKit
import SwiftyJSON
import Alamofire
//
//  Еще один метод для загрузки изображения.
//  Добавляется в стандартный класс UIImageView.
//
extension UIImageView {
    func downloadedFrom(link:String) {
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
            guard let data = data , error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { () -> Void in
                self.image = image
            }
        }).resume()
    }
}
class NewsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sortedData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    //
    //  Данная функция сотрирует данные об активностях по дате добавления.
    //
    func sortedData(){
        newsDATA = newsDATA.sorted(by: {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let op1 = dateFormatter.date(from: $0["time"]!)
            let op2 = dateFormatter.date(from: $1["time"]!)
            return op1! >= op2!
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDATA.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell:FeedsTableViewCell = cell as! FeedsTableViewCell
        cell.userAvatar.downloadedFrom(link: newsDATA[indexPath.row]["avatar_url"]!)
        cell.userName.text = newsDATA[indexPath.row]["name"]
        cell.userCommit.text = newsDATA[indexPath.row]["commit"]
        if newsDATA[indexPath.row]["commit"] == ""{
            cell.userCommit.text = newsDATA[indexPath.row]["action"]
            cell.userAction.text = ""
        }
        cell.userRepo.text = newsDATA[indexPath.row]["repo"]
        cell.commitTime.text = newsDATA[indexPath.row]["time"]
        cell.userAvatar.clipsToBounds = true
    }
    //
    //  В зависимости от того содержит ли активность сообщение пользователя, ячейке
    //  присваивается высота.
    //
    var buff = false
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FeedsTableViewCell", owner: self, options: nil)?.first as! FeedsTableViewCell
        cell.userAvatar.layer.cornerRadius = cell.userAvatar.frame.height / 2
        cell.cellView.clipsToBounds = true
        cell.cellView.layer.cornerRadius = 15
        
        self.tableView.separatorStyle = .none
        
        cell.userAvatar.isUserInteractionEnabled = true
        cell.userAvatar.tag = indexPath.row
        cell.userAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgTapped)))
  
        return cell
    }
    @objc func imgTapped(recognizer: UITapGestureRecognizer){
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        isProfileFiles = false
        let index = (recognizer.view?.tag)!
        let login = newsDATA[index]["name"]!
        Alamofire.request("https://api.github.com/users/" + login, headers: headers).responseJSON{ response in
            otherUserData = JSON(response.result.value!)
            Alamofire.request("https://api.github.com/users/" + login + "/repos", headers: headers).responseJSON{(response) -> Void in
                let json = JSON(response.result.value!)
                for index in 0...(json.count-1){
                    otherRepoData[json[index]["full_name"].string!] = json[index]["url"].string!
                }
                Alamofire.request("https://api.github.com/users/" + login + "/subscriptions", headers: headers).responseJSON{ response in
                    let json = JSON(response.result.value!)
                    for index in 0..<json.count{
                        otherRepoData[json[index]["full_name"].string!] = json[index]["url"].string!
                    }
                    self.performSegue(withIdentifier: "GoToUser", sender: nil)
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}
