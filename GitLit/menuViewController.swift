//
//  menuViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 15.10.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit

class menuViewController: UIViewController {
    
    @IBAction func newsBtnPressed(_ sender: Any) {
        buff = 1
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
