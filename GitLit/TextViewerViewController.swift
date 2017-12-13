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

class TextViewerViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    var lineNumber = 1
    var wholeText = ""
    var stringText = ""
    var filename = ""
    let scaleList = ["100%","50%","25%","10%","150%"]
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scaleBtn: UIBarButtonItem!
    //
    //  Содержимое загруженного файла помещается в textview, затем
    //  файл удаляется.
    //
    var textView = UITextView()
    var leftPanel = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        scaleBtn.title = "100%"
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + filename
        var text = ""
        do {
            let contentsOfFile = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            text = (contentsOfFile as String?)!
        } catch let error as NSError {
            text = "there is an file reading error: \(error)"
        }
        //numberOfLine()
        do {
            try FileManager.default.removeItem(atPath: path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        let maxSize = CGSize(width: 9999, height: 9999)
        let font = UIFont(name: "Menlo", size: 16)!
        //key function is coming!!!
        let strSize = (text as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil)
        
        let frame = CGRect(x: 45, y: 0, width: strSize.width+50, height: strSize.height+100)
        let frameForPanel = CGRect(x: 0, y: 0, width: 45, height: strSize.height+100)
        textView = UITextView(frame: frame)
        leftPanel = UITextView(frame: frameForPanel)
        
        lineNumber = 1
        wholeText = text
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
        
        textView.delegate = self
        leftPanel.delegate = self
        
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = font
        textView.text = text
        
        leftPanel.isEditable = false
        leftPanel.isScrollEnabled = false
        leftPanel.font = font
        leftPanel.text = stringText
        leftPanel.textColor = UIColor.white
        leftPanel.backgroundColor = UIColor.darkGray
        
        scrollView.contentSize = CGSize(width: strSize.width + 35, height: strSize.height)
        scrollView.addSubview(leftPanel)
        scrollView.addSubview(textView)
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scaleList.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = scaleList[row]
        return NSAttributedString(string: str, attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        scaleBtn.title = self.scaleList[row]
        
        if self.scaleList[row] == "100%"{
            let font = UIFont(name: "Menlo", size: 16)!
            textView.font = font
            textView.frame = CGRect(x: 45, y: 0, width: textView.frame.width, height: textView.frame.height)
            leftPanel.font = font
            leftPanel.frame = CGRect(x: 0, y: 0, width: 45, height: leftPanel.frame.height)
        } else if self.scaleList[row] == "50%"{
            let font = UIFont(name: "Menlo", size: 8)!
            textView.font = font
            textView.frame = CGRect(x: 35, y: 0, width: textView.frame.width, height: textView.frame.height)
            leftPanel.font = font
            leftPanel.frame = CGRect(x: 0, y: 0, width: 35, height: leftPanel.frame.height)
        } else if self.scaleList[row] == "150%"{
            let font = UIFont(name: "Menlo", size: 24)!
            textView.font = font
            textView.frame = CGRect(x: 55, y: 0, width: textView.frame.width, height: textView.frame.height)
            leftPanel.font = font
            leftPanel.frame = CGRect(x: 0, y: 0, width: 55, height: leftPanel.frame.height)
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width + 100, height: scrollView.contentSize.height + 100)
        } else if self.scaleList[row] == "25%"{
            let font = UIFont(name: "Menlo", size: 4)!
            textView.font = font
            textView.frame = CGRect(x: 25, y: 0, width: textView.frame.width, height: textView.frame.height)
            leftPanel.font = font
            leftPanel.frame = CGRect(x: 0, y: 0, width: 25, height: leftPanel.frame.height)
        } else if self.scaleList[row] == "10%"{
            let font = UIFont(name: "Menlo", size: 2)!
            textView.font = font
            textView.frame = CGRect(x: 15, y: 0, width: textView.frame.width, height: textView.frame.height)
            leftPanel.font = font
            leftPanel.frame = CGRect(x: 0, y: 0, width: 15, height: leftPanel.frame.height)
        }
        
        self.dropDown.isHidden = true
        
    }
    @IBAction func scaleBtnPressed(_ sender: Any) {
        self.dropDown.isHidden = false
    }
}
