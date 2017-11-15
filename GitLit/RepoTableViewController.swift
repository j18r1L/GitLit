//
//  RepoTableViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 14.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
var branches = [String]()
class RepoTableViewController: UITableViewController {
    var dataCell = [userData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nameRepo = repoDATA.keys
        for namE in nameRepo{
            dataCell.append(userData(
                cell: 2,
                name: namE,
                bio: "",
                image: nil,
                url: repoDATA[namE]
            ))
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
                self.performSegue(withIdentifier: "GoToRepo", sender: nil)
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCell.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("RepositoriesTableViewCell", owner: self, options: nil)?.first as! RepositoriesTableViewCell
        cell.repoName.text = dataCell[indexPath.row].name
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        return cell
    }
    var index = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        getDataForRepo(url: dataCell[index].url!)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let repoVC: RepoLibTableViewController = (segue.destination as? RepoLibTableViewController)!
        repoVC.title = dataCell[index].name
    }
}
