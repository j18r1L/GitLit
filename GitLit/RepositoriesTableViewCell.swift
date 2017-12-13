//
//  RepositoriesTableViewCell.swift
//  GitLit
//
//  Created by Emil Astanov on 02.11.17.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import UIKit

class RepositoriesTableViewCell: UITableViewCell {
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
}
