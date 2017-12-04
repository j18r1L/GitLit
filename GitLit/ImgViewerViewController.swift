//
//  ImgViewerViewController.swift
//  GitLit
//
//  Created by Emil Astanov on 21.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit

class ImgViewerViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        image.downloadedFrom(link: url)
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.image
    }
}
