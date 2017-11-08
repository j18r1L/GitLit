//
//  NewsTableViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 08.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class NewsTableViewController: UITableViewController {
    func avatarImage(url: String) -> UIImage{
        let imgURL: NSURL = NSURL(string: url)!
        let imgData = NSData(contentsOf: imgURL as URL)
        return UIImage(data: imgData! as Data)!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sortedData()
    }
    func sortedData(){
        newsDATA = newsDATA.sorted(by: {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let op1 = dateFormatter.date(from: $0["time"]!)
            let op2 = dateFormatter.date(from: $1["time"]!)
            return op1! >= op2!
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsDATA.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FeedsTableViewCell", owner: self, options: nil)?.first as! FeedsTableViewCell
        //print(newsDATA[indexPath.row])
        //self.tableView.contentInset = UIEdgeInsets(top: (self.navigationController?.navigationBar.frame.size.height)!+15, left: 0, bottom: 0,right: 0)
        cell.userAvatar.image = avatarImage(url: newsDATA[indexPath.row]["avatar_url"]!)
        cell.userName.text = newsDATA[indexPath.row]["name"]
        cell.userCommit.text = newsDATA[indexPath.row]["commit"]
        cell.userRepo.text = newsDATA[indexPath.row]["repo"]
        cell.commitTime.text = newsDATA[indexPath.row]["time"]
        //print(newsDATA[indexPath.row]["time"])
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
