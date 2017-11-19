//
//  RepoLibTableViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 15.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//
//  Данный класс отображает данные репозитория.
//
import UIKit
import Alamofire
import SwiftyJSON
//
//  Перечисление для отличия файла от папки.
//
enum FileType {
    case dir
    case file
}
//
//  Структура для хранения данных файла.
//
struct File{
    var type: FileType
    var name: String
    var url: String
}
var filehierarchy = [File]()
class RepoLibTableViewController: UITableViewController {
    var repo = ""
    //
    //  Данная функция строет строит иерархию, разделяя файлы и папки.
    //
    func getDataForBranch(url: JSON, name: String, dir: String){
        if url["download_url"] != JSON.null{
            filehierarchy.append(File(type: .file, name: name, url: url["download_url"].string!))
        } else {
            filehierarchy.append(File(type: .dir, name: name, url: url["url"].string!))
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("RepositoriesTableViewCell", owner: self, options: nil)?.first as! RepositoriesTableViewCell
        cell.repoName.text = branches[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        return cell
    }

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
            for ind in 0...data.count-1{
                self.getDataForBranch(url: data[ind], name: data[ind]["name"].string!, dir: branches[indexPath.row])
            }
            self.performSegue(withIdentifier: "GoToBranch", sender: nil)
        }
    }
    //
    //  Устанавливается заголовок для следующего представления.
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let branchVC: BranchTableViewController = (segue.destination as? BranchTableViewController)!
        branchVC.title = branches[index]
    }
    //
    //  Обработка кнопки возвращения назад.
    //
    @IBAction func backBtnPressed(_ sender: Any) {
        filehierarchy = [File]()
        backFileHierarchy = [File]()
        self.navigationController?.popViewController(animated: true)
    }
    //
    //  Данная функция сначала рекурентно загружала все файлы выбранной ветки репозитория.
    //  Другими словами, функция выполняет команду "git clone"
    //  В дальнейшем я осознал, что в этом нет необходимости. И отказался от загрузки всех
    //  файлов сразу. Но это функцию я не могу просто так взять и стереть, поэтому,
    //  пусть она просто будет здесь)
    //
    /*
    func getDataForBranch(url: JSON, name: String, dir: String){
        let headers = [
         "Authorization" : "Basic " + UserDefaults.standard.string(forKey: "token")!
         ]
        if url["download_url"] != nil{
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
             documentsURL.appendPathComponent(self.repo + "/" + dir + "/" + name)
             return (documentsURL, [.removePreviousFile])
             }
             Alamofire.download(url["download_url"].string!, method: .get, encoding: JSONEncoding.default, headers: headers, to: destination)
        } else {
             let dir = dir + "/" + name
             Alamofire.request(url["url"].string!, headers: headers).responseJSON{(response) -> Void in
             let data = JSON(response.result.value!)
             for ind in 0...data.count-1{
             self.getDataForBranch(url: data[ind], name: data[ind]["name"].string!, dir: dir)
             }
             }
        }
    }
     */
}
