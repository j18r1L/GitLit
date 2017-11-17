//
//  RepoLibTableViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 15.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
enum FileType {
    case dir
    case file
}
struct File{
    var type: FileType
    var name: String
    var url: String
}
var filehierarchy = [File]()
class RepoLibTableViewController: UITableViewController {
    var repo = ""
    func getDataForBranch(url: JSON, name: String, dir: String){
        /*let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]*/
        if url["download_url"] != nil{
            filehierarchy.append(File(type: .file, name: name, url: url["download_url"].string!))
            /*let dataPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
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
                documentsURL.appendPathComponent(self.repo + "/" + dir + "/" + name)
                return (documentsURL, [.removePreviousFile])
            }
            Alamofire.download(url["download_url"].string!, method: .get, encoding: JSONEncoding.default, headers: headers, to: destination)*/
        } else {
            filehierarchy.append(File(type: .dir, name: name, url: url["url"].string!))
            /*let dir = dir + "/" + name
            Alamofire.request(url["url"].string!, headers: headers).responseJSON{(response) -> Void in
                let data = JSON(response.result.value!)
                for ind in 0...data.count-1{
                    self.getDataForBranch(url: data[ind], name: data[ind]["name"].string!, dir: dir)
                }
            }*/
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return branches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("RepositoriesTableViewCell", owner: self, options: nil)?.first as! RepositoriesTableViewCell
        cell.repoName.text = branches[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        return cell
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    var index = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filehierarchy = [File]()
        index = indexPath.row
        let headers = [
            "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
        ]
        let param = ["ref": branches[indexPath.row]]
        Alamofire.request("https://api.github.com/repos/" + repo + "/contents",parameters: param, headers: headers).responseJSON{(response) -> Void in
            let data = JSON(response.result.value!)
            //print(data)
            for ind in 0...data.count-1{
                self.getDataForBranch(url: data[ind], name: data[ind]["name"].string!, dir: branches[indexPath.row])
            }
            self.performSegue(withIdentifier: "GoToBranch", sender: nil)
        }
        /*do {
            let items = try FileManager.default.contentsOfDirectory(atPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            
            for item in items {
                print("Found \(item)")
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }*/
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let branchVC: BranchTableViewController = (segue.destination as? BranchTableViewController)!
        branchVC.directory = repo + "/" + branches[index]
        branchVC.title = branches[index]
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        filehierarchy = [File]()
        backFileHierarchy = [File]()
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
