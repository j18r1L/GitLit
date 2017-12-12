//
//  BranchTableViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 16.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//
//  Данный класс отображает иерархию файлов и папок выбранной ветки.
//
import UIKit
import Alamofire
import SwiftyJSON
var backFileHierarchy = [File]()
class BranchTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filehierarchy.count
    }
    //
    //  Ниже можно наблюдать двольно странное условие.
    //  Таким образом я исключаю ошибку "Index out of range".
    //  В случаи ошибки нас просто отбрасывает назад, и приложение не вылетает.
    //  Я четно пытался предотвратить ее возникновение, но все мои попытки тщетны...
    //  Она возникает, так как иногда происходит збой записи переменных filehierarchy и
    //  backFileHierarchy.
    //  Ошибка возникает крайне редко!
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= filehierarchy.count{
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
            case .img:
                let cell = Bundle.main.loadNibNamed("ImgTableViewCell", owner: self, options: nil)?.first as! ImgTableViewCell
                cell.imgName.text = filehierarchy[indexPath.row].name
                cell.selectionStyle = UITableViewCellSelectionStyle.blue
                return cell
            }
        } else{
            print("Error: Index out of range!")
            self.navigationController?.popViewController(animated: false)
            return Bundle.main.loadNibNamed("DirTableViewCell", owner: self, options: nil)?.first as! DirTableViewCell
        }
    }
    var index = 0
    func getDataForBranch(url: JSON, name: String){
        if url["download_url"] != JSON.null{
            filehierarchy.append(File(type: .file, name: name, url: url["download_url"].string!))
        } else {
            filehierarchy.append(File(type: .dir, name: name, url: url["url"].string!))
        }
    }
    //
    //  При нажатии на файл, он загружается и передается в text viewer.
    //  При нажатии на папку отображается ее содержимое.
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        if index <= filehierarchy.count{
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
                    FileVC?.title = filehierarchy[indexPath.row].name
                    backFileHierarchy = filehierarchy
                    filehierarchy = [File]()
                    for ind in 0...data.count-1{
                        self.getDataForBranch(url: data[ind], name: data[ind]["name"].string!)
                    }
                    self.navigationController?.pushViewController(FileVC!, animated: true)
                }
            case .img:
                self.performSegue(withIdentifier: "GoToImg", sender: nil)
            }
        } else {
            print("Error: Index out of range!")
            self.navigationController?.popViewController(animated: false)
        }
    }
    //
    //  Передача заголовка и данных в следующий контроллер.
    //
    func avatarImage(url: String) -> UIImage{
        let imgURL: NSURL = NSURL(string: url)!
        let imgData = NSData(contentsOf: imgURL as URL)
        return UIImage(data: imgData! as Data)!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch filehierarchy[index].type {
        case .file:
            let textVC: TextViewerViewController = (segue.destination as? TextViewerViewController)!
            textVC.title = filehierarchy[index].name
            textVC.filename = filehierarchy[index].name
        case .img:
            let imgVC: ImgViewerViewController = (segue.destination as? ImgViewerViewController)!
            imgVC.title = filehierarchy[index].name
            imgVC.url = filehierarchy[index].url
        case .dir:
            return
        }
    }
    //
    //  Обработка возвращения назад.
    //
    @IBAction func backBtnPressed(_ sender: Any) {
        filehierarchy = backFileHierarchy
        self.navigationController?.popViewController(animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
