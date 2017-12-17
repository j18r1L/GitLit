//
//  HomeTableViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 25.10.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//
//  Данный класс отображает основные данные пользователя.
//
import UIKit
import SwiftyJSON
import Alamofire
//
//  Структура для хранения данных о пользователе.
//
struct userData {
    let name : String!
    let bio : String!
    let image : UIImage!
    let url: String!
}
//
//  Перечесление для отличия секции "репозитории" от "аккаунт".
//
private enum SectionType {
    case Account
    case Repos
    case Followers
    case Logo
}
//
//  Перечисление для отличия ячейки "пользователь" от "репозиторий"
//
private enum Item {
    case User
    case Repo
    case follower
    case logo
}
//
//  Структура для хранения данных ячейки.
//
private struct Section {
    var type: SectionType
    var items: [Item]
    var data: [String]
}

var isProfileFiles = false
var filepath = [String: String]()

class HomeTableViewController: UITableViewController{
    private var sections = [Section]()
    var dataCell = [userData]()
    var repolist = [String]()
    let loadindicator = UIActivityIndicatorView()
    func avatarImage(url: String) -> UIImage{
        if isWebConnect == true{
            let imgURL: NSURL = NSURL(string: url)!
            let imgData = NSData(contentsOf: imgURL as URL)
            return UIImage(data: imgData! as Data)!
        }else{
            return #imageLiteral(resourceName: "profile")
        }
    }
    //
    //  При отображении контроллера, все данные структурируются и записываются в соответствующие
    //  массивы.
    //
    override func viewDidLoad() {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.navigationController?.navigationBar.addSubview(loadindicator)
        loadindicator.frame = CGRect(x: (navigationController?.navigationBar.frame.width)! / 2 , y: (navigationController?.navigationBar.frame.height)! / 6, width: loadindicator.frame.width, height: loadindicator.frame.height)

        if isWebConnect{
            for name in repoDATA.keys{
                repolist.append(name)
            }
            sections = [
                Section(type: .Account, items: [.User], data: [""]),
                Section(type: .Repos, items: [.Repo], data: repolist),
                Section(type: .Followers, items: [.follower], data: followers),
                Section(type: .Logo, items: [.logo], data: [""])
            ]
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
            } else if authDATA["bio"].string == nil{
                dataCell = [userData(
                    name: authDATA["name"].string!,
                    bio: "",
                    image: avatarImage(url: authDATA["avatar_url"].string!),
                    url: nil
                    )]
            } else {
                dataCell = [userData(
                    name: authDATA["name"].string!,
                    bio: authDATA["bio"].string!,
                    image: avatarImage(url: authDATA["avatar_url"].string!),
                    url: nil
                    )]
            }
        } else {
            repoDATA = UserDefaults.standard.dictionary(forKey: "repoDATA") as! [String : String]
            for name in repoDATA.keys{
                repolist.append(name)
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isWebConnect{
            return sections.count
        } else {return 1}
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isWebConnect{
            return sections[section].data.count
        } else {return repolist.count}
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isWebConnect{
            switch sections[section].type {
            case .Account:
                return nil
            case .Repos:
                return "Repositories"
            case .Followers:
                return "Followers"
            case .Logo:
                return nil
            }
        } else{
            return "Repositories"
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isWebConnect{
            switch sections[indexPath.section].items[0] {
            case .User:
                let cell = Bundle.main.loadNibNamed("AboutUserTableViewCell", owner: self, options: nil)?.first as! AboutUserTableViewCell
                
                tableView.sectionFooterHeight = 20
                cell.backGround.clipsToBounds = true
                cell.backGround.layer.cornerRadius = 20
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
            case .follower:
                let cell = Bundle.main.loadNibNamed("RepositoriesTableViewCell", owner: self, options: nil)?.first as! RepositoriesTableViewCell
                cell.repoName.text = followers[indexPath.row]
                cell.avatarImg.downloadedFrom(link: followersList[followers[indexPath.row]]!)
                cell.avatarImg.clipsToBounds = true
                cell.avatarImg.layer.cornerRadius = cell.avatarImg.frame.height / 2
                return cell
            case .logo:
                let cell = Bundle.main.loadNibNamed("LogoTableViewCell", owner: self, options: nil)?.first as! LogoTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }
        } else {
            let cell = Bundle.main.loadNibNamed("RepositoriesTableViewCell", owner: self, options: nil)?.first as! RepositoriesTableViewCell
            cell.repoName.text = repolist[indexPath.row]
            cell.selectionStyle = UITableViewCellSelectionStyle.blue
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isWebConnect{
            switch sections[section].type {
            case .Account:
                return 1
            case .Repos:
                return 25
            case .Followers:
                return 25
            case .Logo:
                return 50
            }
        } else {
            return 25
        }
    }
    //
    //  В зависимости от типа ячейки ей присваивается разная высота.
    //
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isWebConnect{
            switch sections[indexPath.section].items[0] {
            case .User:
                return 107
            case .Repo:
                return 45
            case .follower:
                return 45
            case .logo:
                return 161
            }
        } else {
            return 45
        }
    }
    var index = 0
    //
    //  При нажатии на любую ячеку секции "репозитории" открывается вкладка "рипозитории"
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isWebConnect {
            switch sections[indexPath.section].items[0] {
            case .Repo:
                getBranch(url: repoDATA[repolist[indexPath.row]]!, repo: repolist[indexPath.row])
            //tabBarController?.selectedIndex = 2
            case .follower:
                loadindicator.startAnimating()
                loadindicator.isHidden = false
                
                isProfileFiles = false
                self.loadindicator.startAnimating()
                Alamofire.request("https://api.github.com/users/" + followers[indexPath.row]).responseJSON{ response in
                    otherUserData = JSON(response.result.value!)
                    Alamofire.request("https://api.github.com/users/" + followers[indexPath.row] + "/repos").responseJSON{(response) -> Void in
                        let json = JSON(response.result.value!)
                        for index in 0..<json.count{
                            otherRepoData[json[index]["full_name"].string!] = json[index]["url"].string!
                        }
                        Alamofire.request("https://api.github.com/users/" + followers[indexPath.row] + "/subscriptions").responseJSON{ response in
                            let json = JSON(response.result.value!)
                            for index in 0..<json.count{
                                otherRepoData[json[index]["full_name"].string!] = json[index]["url"].string!
                            }
                            self.loadindicator.stopAnimating()
                            self.loadindicator.isHidden = true
                            self.performSegue(withIdentifier: "GoToUser", sender: nil)
                        }
                    }
                }
            case .User:
                return
            case .logo:
                return
            }
        } else {
            getBranch(url: repoDATA[repolist[indexPath.row]]!, repo: repolist[indexPath.row])
        }
    }
    func getBranch(url: String, repo: String){
        loadindicator.startAnimating()
        loadindicator.isHidden = false
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        if isWebConnect{
            Alamofire.request(url+"/branches", headers: headers).responseJSON{(response) -> Void in
                let data = JSON(response.result.value!)
                branches = [String]()
                filepath = [String: String]()
                for ind in 0..<data.count{
                    if let branch: String = data[ind]["name"].string{
                        branches.append(branch)
                        let param = ["ref": branch]
                        Alamofire.request(url + "/contents",parameters: param, headers: headers).responseJSON{(response) -> Void in
                            let data = JSON(response.result.value!)
                            for fileInd in 0..<data.count{
                                self.getBranchesData(url: data[fileInd], repo: repo, dir: branch, name: data[fileInd]["name"].string!)
                            }
                        }
                        filepath[branch] = "/" + repo + "/" + branch
                    }
                }
                UserDefaults.standard.set(branches, forKey: repo)
                UserDefaults.standard.set(filepath, forKey: repo + "path")
                isProfileFiles = true
                self.loadindicator.stopAnimating()
                self.loadindicator.isHidden = true
                self.performSegue(withIdentifier: "GoToRepo", sender: nil)
            }
        } else {
            branches = UserDefaults.standard.array(forKey: repo) as! [String]
            filepath = UserDefaults.standard.dictionary(forKey: repo + "path") as! [String : String]
            isProfileFiles = true
            self.loadindicator.stopAnimating()
            self.loadindicator.isHidden = true
            self.performSegue(withIdentifier: "GoToRepo", sender: nil)
        }
    }
    func getBranchesData(url: JSON, repo: String, dir: String, name: String){
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        if url["download_url"] != JSON.null{
            let dataPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let repoDir = dataPath + "/" + repo + "/" + dir
            var objCtBool:ObjCBool = true
            let isExit = FileManager.default.fileExists(atPath: repoDir, isDirectory: &objCtBool)
            if isExit == false{
                do{
                    try FileManager.default.createDirectory(atPath: repoDir, withIntermediateDirectories: true, attributes: nil)
                }catch
                {
                    print("error create directory")
                }
            }
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent(repo + "/" + dir + "/" + name)
                return (documentsURL, [.removePreviousFile])
            }
            Alamofire.download(url["download_url"].string!, method: .get, encoding: JSONEncoding.default, headers: headers, to: destination)
        } else {
            let dir = dir + "/" + name
            Alamofire.request(url["url"].string!, headers: headers).responseJSON{(response) -> Void in
                let data = JSON(response.result.value!)
                for ind in 0...data.count-1{
                    self.getBranchesData(url: data[ind], repo: repo, dir: dir, name: data[ind]["name"].string!)
                }
            }
        }
    }
}
