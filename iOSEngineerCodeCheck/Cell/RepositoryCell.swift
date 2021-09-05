//
//  RepositoryCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 大江祥太郎 on 2021/09/05.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import SDWebImage

class RepositoryCell: UITableViewCell {

    @IBOutlet private weak var ownerImageView: UIImageView!{
        didSet {
            ownerImageView.layer.cornerRadius = 8
            ownerImageView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var repositoryDescriptionLabel: UILabel!
    
    static let cellIdentifier = String(describing: RepositoryCell.self)

    func setData(repository: Repository) {
        repositoryNameLabel.text = repository.fullName

        if let url = repository.avatarImageUrl {
            ownerImageView.sd_setImage(with: url, completed: nil)
        } else {
            ownerImageView.image = nil
        }
        repositoryDescriptionLabel.text = repository.description ?? ""
        accessoryType = .disclosureIndicator
    }
}
