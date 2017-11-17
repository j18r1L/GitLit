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
    let name : String!
    let bio : String!
    let image : UIImage!
    let url: String!
}
private enum SectionType {
    case Account
    case Repos
}
private enum Item {
    case User
    case Repo
}
private struct Section {
    var type: SectionType
    var items: [Item]
    var data: [String: String]
}
class HomeTableViewController: UITableViewController{
    private var sections = [Section]()
    var dataCell = [userData]()
    var repolist = [String]()
    func avatarImage(url: String) -> UIImage{
        let imgURL: NSURL = NSURL(string: url)!
        let imgData = NSData(contentsOf: imgURL as URL)
        return UIImage(data: imgData! as Data)!
    }
    override func viewDidLoad() {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        sections = [
            Section(type: .Account, items: [.User], data: ["":""]),
            Section(type: .Repos, items: [.Repo], data: repoDATA)
        ]
        self.navigationItem.title = "Login"
        if authDATA["bio"].string == nil && authDATA["name"].string == nil{
            dataCell = [userData(
                name: "",
                bio: "",
                image: avatarImage(url: authDATA["avatar_url"].string!),
                url: nil
            )]
        } else if authDATA["name"].string == nil{
            dataCell = [userData(
                name: "",
                bio: authDATA["bio"].string!,
                image: avatarImage(url: authDATA["avatar_url"].string!),
                url: nil
            )]
        } else {
            dataCell = [userData(
                name: authDATA["name"].string!,
                bio: "",
                image: avatarImage(url: authDATA["avatar_url"].string!),
                url: nil
            )]
        }
        for name in repoDATA.keys{
            repolist.append(name)
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].data.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section].type {
        case .Account:
            return nil
        case .Repos:
            return "Repositories"
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].items[0] {
        case .User:
            let cell = Bundle.main.loadNibNamed("AboutUserTableViewCell", owner: self, options: nil)?.first as! AboutUserTableViewCell
            cell.userAvatar.image = dataCell[indexPath.row].image
            cell.userAvatar.clipsToBounds = true
            cell.userAvatar.layer.cornerRadius = cell.userAvatar.frame.height / 2
            cell.userBio.text = dataCell[indexPath.row].bio
            cell.userName.text = dataCell[indexPath.row].name
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        case .Repo:
            let cell = Bundle.main.loadNibNamed("RepositoriesTableViewCell", owner: self, options: nil)?.first as! RepositoriesTableViewCell
            cell.repoName.text = repolist[indexPath.row]
            cell.selectionStyle = UITableViewCellSelectionStyle.blue
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].items[0] {
        case .User:
            return 95
        case .Repo:
            return 45
        }
    }
    var index = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].items[0] {
        case .Repo:
            tabBarController?.selectedIndex = 2
        case .User:
            return
        }
    }
}
