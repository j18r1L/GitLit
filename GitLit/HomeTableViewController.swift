//
//  HomeTableViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 25.10.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
struct userData {
    let cell : Int!
    let name : String!
    let bio : String!
    let image : UIImage!
    let url: String!
}

class HomeTableViewController: UITableViewController{
    var dataCell = [userData]()
    var dataTable = [[String: String]]()
    override func viewDidLoad() {
        self.navigationItem.title = "Login"
        let nameRepo = repoDATA.keys
        dataCell = [userData(
            cell: 1,
            name: authDATA["name"].string!,
            bio: authDATA["bio"].string!,
            image: avatarImage(url: authDATA["avatar_url"].string!),
            url: nil
        )]
        dataCell.append(userData(
            cell: 3,
            name: "Repositories",
            bio: nil,
            image: nil,
            url: nil
        ))
        for namE in nameRepo{
            dataCell.append(userData(
                cell: 2,
                name: namE,
                bio: "",
                image: nil,
                url: repoDATA[namE]
            ))
        }
        //print(dataCell)
        //self.title = authDATA["login"].string!
    }
    func avatarImage(url: String) -> UIImage{
        let imgURL: NSURL = NSURL(string: url)!
        let imgData = NSData(contentsOf: imgURL as URL)
        return UIImage(data: imgData! as Data)!
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCell.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataCell[indexPath.row].cell == 1{
            let cell = Bundle.main.loadNibNamed("AboutUserTableViewCell", owner: self, options: nil)?.first as! AboutUserTableViewCell
            cell.userAvatar.image = dataCell[indexPath.row].image
            cell.userBio.text = dataCell[indexPath.row].bio
            cell.userName.text = dataCell[indexPath.row].name
            //self.tableView.contentInset = UIEdgeInsets(top: (self.navigationController?.navigationBar.frame.size.height)!+15, left: 0, bottom: 0,right: 0)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        } else if dataCell[indexPath.row].cell == 2{
            let cell = Bundle.main.loadNibNamed("RepositoriesTableViewCell", owner: self, options: nil)?.first as! RepositoriesTableViewCell
            cell.repoName.text = dataCell[indexPath.row].name
            cell.selectionStyle = UITableViewCellSelectionStyle.blue
            return cell
        }else if dataCell[indexPath.row].cell == 3{
            let cell = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?.first as! HeaderTableViewCell
            cell.header.text = dataCell[indexPath.row].name
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("RepositoriesTableViewCell", owner: self, options: nil)?.first as! RepositoriesTableViewCell
            cell.repoName.text = "_"
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataCell[indexPath.row].cell == 1{
            return 95
        }else if dataCell[indexPath.row].cell == 3{
            return 36
        }else{
            return 45
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.openURL(NSURL(string: dataCell[indexPath.row].url)! as URL)
    }
}
