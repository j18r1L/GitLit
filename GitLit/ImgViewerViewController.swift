//
//  ImgViewerViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 21.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit

class ImgViewerViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        image.downloadedFrom(link: url)
    }
}
