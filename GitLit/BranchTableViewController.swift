//
//  BranchTableViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 16.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
var backFileHierarchy = [File]()
class BranchTableViewController: UITableViewController {
    var directory = ""
    var filelist = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func getFileList(){
        filelist = try! FileManager.default.contentsOfDirectory(atPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + directory)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filehierarchy.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch filehierarchy[indexPath.row].type {
        case .file:
            let cell = Bundle.main.loadNibNamed("RepositoriesTableViewCell", owner: self, options: nil)?.first as! RepositoriesTableViewCell
            cell.repoName.text = filehierarchy[indexPath.row].name
            cell.selectionStyle = UITableViewCellSelectionStyle.blue
            return cell
        case .dir:
            let cell = Bundle.main.loadNibNamed("DirTableViewCell", owner: self, options: nil)?.first as! DirTableViewCell
            cell.dirName.text = filehierarchy[indexPath.row].name
            cell.selectionStyle = UITableViewCellSelectionStyle.blue
            return cell
        }
        
    }
    var index = 0
    func getDataForBranch(url: JSON, name: String){
        if url["download_url"] != nil{
            filehierarchy.append(File(type: .file, name: name, url: url["download_url"].string!))
        } else {
            filehierarchy.append(File(type: .dir, name: name, url: url["url"].string!))
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        //self.performSegue(withIdentifier: "GoToText", sender: nil)
        switch filehierarchy[indexPath.row].type {
        case .file:
            let headers = [
                "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
            ]
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent(filehierarchy[indexPath.row].name)
                return (documentsURL, [.removePreviousFile])
            }
            Alamofire.download(filehierarchy[indexPath.row].url, method: .get, encoding: JSONEncoding.default, headers: headers, to: destination).downloadProgress{ DefaultDownloadResponse in
             self.performSegue(withIdentifier: "GoToText", sender: nil)
            }
            
        case .dir:
            let FileVC = self.storyboard?.instantiateViewController(withIdentifier: "FileHierarchy")
            let headers = [
                "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
            ]
            Alamofire.request(filehierarchy[indexPath.row].url, headers: headers).responseJSON{(response) -> Void in
                let data = JSON(response.result.value!)
                backFileHierarchy = filehierarchy
                filehierarchy = [File]()
                //print(data)
                for ind in 0...data.count-1{
                    self.getDataForBranch(url: data[ind], name: data[ind]["name"].string!)
                }
                self.navigationController?.pushViewController(FileVC!, animated: true)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let textVC: TextViewerViewController = (segue.destination as? TextViewerViewController)!
        textVC.title = filehierarchy[index].name
        textVC.filename = filehierarchy[index].name
        /*let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" +
        do {
            let contentsOfFile = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            textVC.content = (contentsOfFile as String?)!
        } catch let error as NSError {
            print("there is an file reading error: \(error)")
        }*/
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        filehierarchy = backFileHierarchy
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
