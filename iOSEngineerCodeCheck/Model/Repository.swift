//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by 大江祥太郎 on 2021/09/04.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

struct Repositories: Codable {
    let items: [Repository]
}

struct Repository: Codable {
    let id: Int
    let name: String
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let description: String?
    let homepage: String?
    let htmlUrl: String?
    
    let owner: Owner

    var avatarImageUrl: URL? {
        return URL(string: owner.avatarUrl)
    }
}

struct Owner: Codable {
    let avatarUrl: String
    let login: String
    
}


