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
    case img
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
var files = [String]()
class RepoLibTableViewController: UITableViewController {
    var repo = ""
    //
    //  Данная функция строет строит иерархию, разделяя файлы и папки.
    //
    func getDataForBranch(url: JSON, name: String, dir: String){
        if url["download_url"] != JSON.null{
            let type3x = name[name.index(name.endIndex, offsetBy: -3)...]
            let type4x = name[name.index(name.endIndex, offsetBy: -4)...]
            if type3x == "png" || type3x == "jpg" || type3x  == "bmp" || type3x == "tif" || type3x == "gif" || type3x == "PNG" || type3x == "JPG" || type3x  == "BMP" || type3x == "TIF" || type3x == "GIF"{
                filehierarchy.append(File(type: .img, name: name, url: url["download_url"].string!))
            }else if type4x == "jpeg" || type4x == "JPEG" || type4x == "tiff" || type4x == "TIFF"{
                filehierarchy.append(File(type: .img, name: name, url: url["download_url"].string!))
            } else {
                filehierarchy.append(File(type: .file, name: name, url: url["download_url"].string!))
            }
        } else {
            filehierarchy.append(File(type: .dir, name: name, url: url["url"].string!))
        }
    }
    func getDataForProfileBranch(path: String){
        let fileManager = FileManager.default

        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            for file in files{
                print(path)
                var isDir : ObjCBool = false
                if fileManager.fileExists(atPath: path + "/" + file, isDirectory:&isDir) {
                    if isDir.boolValue {
                        print("\(file) is dir")
                        filehierarchy.append(File(type: .dir, name: file, url: path + "/" + file))
                    } else {
                        let ext = ((path+"/"+file) as NSString).pathExtension
                        if ext == "png" || ext == "jpg" || ext  == "bmp" || ext == "tif" || ext == "gif" || ext == "PNG" || ext == "JPG" || ext  == "BMP" || ext == "TIF" || ext == "GIF" || ext == "jpeg" || ext == "JPEG" || ext == "tiff" || ext == "TIFF"{
                            filehierarchy.append(File(type: .img, name: file, url: path + "/" + file))
                        } else {
                            filehierarchy.append(File(type: .file, name: file, url: path + "/" + file))
                        }
                    }
                } else {
                    filehierarchy.append(File(type: .file, name: file, url: path + "/" + file))
                }
            }
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
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
        if isProfileFiles{
            getDataForProfileBranch(path: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]+filepath[branches[indexPath.row]]!)
            self.performSegue(withIdentifier: "GoToBranch", sender: nil)
        } else {
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
    }
    //
    //  Устанавливается заголовок для следующего представления.
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let branchVC: BranchTableViewController = (segue.destination as? BranchTableViewController)!
        branchVC.title = branches[index]
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
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
