//
//  MenuViewController.swift
//  GitLit
//
//  Created by Марк on 12.10.2017.
//  Copyright © 2017 GitLit. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate {
    func menuCloseButtonTapped()
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Profile"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "News"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Repositories"
        }
        return cell
    }
    //Press cell controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let newsViewController = storyboard?.instantiateViewController(withIdentifier: "NewsVC")
        //if "News" pressed - show NewsViewController
        if(indexPath.row == 1){
            self.navigationController?.pushViewController(newsViewController!, animated: true)
        }
    }
    
    @IBAction func menuClosedDidTouch(_ sender: AnyObject) {
        delegate?.menuCloseButtonTapped()
    }
    
}
