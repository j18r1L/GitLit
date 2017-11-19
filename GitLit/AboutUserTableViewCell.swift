//
//  AboutUserTableViewCell.swift
//  GitLit
//
//  Created by Emil Astanov on 28.10.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit

class AboutUserTableViewCell: UITableViewCell {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        userAvatar.layer.cornerRadius = 50
    }
    
}
