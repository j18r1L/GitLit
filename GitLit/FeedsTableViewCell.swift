//
//  FeedsTableViewCell.swift
//  GitLit
//
//  Created by Emil Astanov on 08.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userRepo: UILabel!
    @IBOutlet weak var userCommit: UILabel!
    @IBOutlet weak var commitTime: UILabel!
    @IBOutlet weak var userAction: UILabel!
    @IBOutlet weak var cellView: UIView!
}
