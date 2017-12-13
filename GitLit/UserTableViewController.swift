//
//  UserTableViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 21.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//
//  Класс аналогичный Home
//
import UIKit
import SwiftyJSON
import Alamofire
//
//  Перечесление для отличия секции "репозитории" от "аккаунт".
//
private enum SectionType {
    case Account
    case Repos
    case Logo
}
//
//  Перечисление для отличия ячейки "пользователь" от "репозиторий"
//
private enum Item {
    case User
    case Repo
    case logo
}
//
//  Структура для хранения данных ячейки.
//
private struct Section {
    var type: SectionType
    var items: [Item]
    var data: [String: String]
}
var otherRepoData = [String: String]()
var otherUserData = JSON("")
class UserTableViewController: UITableViewController {
    private var sections = [Section]()
    var repolist = [String]()
    var dataCell = [userData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [
            Section(type: .Account, items: [.User], data: ["":""]),
            Section(type: .Repos, items: [.Repo], data: otherRepoData),
            Section(type: .Logo, items: [.logo], data: ["":""])
        ]
        self.title = otherUserData["login"].string!
        if otherUserData["bio"].string == nil && otherUserData["name"].string == nil{
            dataCell = [userData(
                name: "",
                bio: "",
                image: nil,
                url: otherUserData["avatar_url"].string!
                )]
        } else if otherUserData["name"].string == nil{
            dataCell = [userData(
                name: "",
                bio: otherUserData["bio"].string!,
                image: nil,
                url: otherUserData["avatar_url"].string!
                )]
        } else if otherUserData["bio"].string == nil{
            dataCell = [userData(
                name: otherUserData["name"].string!,
                bio: "",
                image: nil,
                url: otherUserData["avatar_url"].string!
                )]
        } else {
            dataCell = [userData(
                name: otherUserData["name"].string!,
                bio: otherUserData["bio"].string!,
                image: nil,
                url: otherUserData["avatar_url"].string!
                )]
        }
        for name in otherRepoData.keys{
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
        case .Logo:
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].items[0] {
        case .User:
            let cell = Bundle.main.loadNibNamed("AboutUserTableViewCell", owner: self, options: nil)?.first as! AboutUserTableViewCell
            tableView.sectionFooterHeight = 20
            cell.backGround.clipsToBounds = true
            cell.backGround.layer.cornerRadius = 20
            cell.userAvatar.downloadedFrom(link: dataCell[indexPath.row].url)
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
        case .logo:
            let cell = Bundle.main.loadNibNamed("LogoTableViewCell", owner: self, options: nil)?.first as! LogoTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section].type {
        case .Account:
            return 1
        case .Repos:
            return 25
        case .Logo:
            return 50
        }
    }
    //
    //  В зависимости от типа ячейки ей присваивается разная высота.
    //
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].items[0] {
        case .User:
            return 107
        case .Repo:
            return 45
        case .logo:
            return 161
        }
    }
    func getDataForRepo(url: String){
        branches = [String]()
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        Alamofire.request(url, headers: headers).responseJSON{ response in
            let jsonResp = JSON(response.result.value!)
            let branchUrl = (jsonResp["branches_url"].string!).replacingOccurrences(of: "{/branch}", with: "")
            Alamofire.request(branchUrl, headers: headers).responseJSON{ response in
                let jsonResp = JSON(response.result.value!)
                for ind in 0...jsonResp.count-1{
                    branches.append(jsonResp[ind]["name"].string!)
                }
                self.performSegue(withIdentifier: "GoToRepoFromAtherUser", sender: nil)
            }
        }
    }
    var index = 0
    //
    //  При нажатии на любую ячеку секции "репозитории" открывается вкладка "рипозитории"
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        switch sections[indexPath.section].items[0] {
        case .Repo:
            getDataForRepo(url: otherRepoData[repolist[indexPath.row]]!)
        case .User:
            return
        case .logo:
            return
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let repoVC: RepoLibTableViewController = (segue.destination as? RepoLibTableViewController)!
        repoVC.title = repolist[index]
        repoVC.repo = repolist[index]
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        otherRepoData = [String: String]()
        otherUserData = JSON("")
        self.navigationController?.popViewController(animated: true)
    }
}
