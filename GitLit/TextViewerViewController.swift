//
//  TextViewerViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 17.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//
//  Данный класс отображает просмоторщик текста.
//
import UIKit

class TextViewerViewController: UIViewController, UITextViewDelegate{
    var lineNumber = 1
    var wholeText = ""
    var stringText = ""
    var content = ""
    var filename = ""
    @IBOutlet weak var leftPanel: UITextView!
    @IBOutlet weak var generalPanel: UITextView!
    //
    //  Содержимое загруженного файла помещается в textview, затем
    //  файл удаляется.
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        leftPanel.delegate = self
        generalPanel.delegate = self

        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + filename
        do {
            let contentsOfFile = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            generalPanel.text = (contentsOfFile as String?)
        } catch let error as NSError {
            generalPanel.text = "there is an file reading error: \(error)"
        }
        numberOfLine()
        do {
            try FileManager.default.removeItem(atPath: path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    //
    //  Эта функция позваляет осуществлять scrolling двух textview одновременно.
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.leftPanel{
            generalPanel.contentOffset = leftPanel.contentOffset
        } else if scrollView == self.generalPanel{
            leftPanel.contentOffset = generalPanel.contentOffset
        }
    }

    //
    //  Данная функция отображает номер линий.
    //
    func numberOfLine(){
        lineNumber = 1
        wholeText = generalPanel.text
        for text in wholeText.characters{
            if text == "\n"{
                lineNumber = lineNumber + 1
                stringText = ""
                for ind in 1...lineNumber{
                    stringText = stringText + "\(ind).\n"
                }
            }
        }
        leftPanel.text = stringText
    }
}
