//
//  GitHubRepository.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

import Foundation

struct SearchRepositoriesResponse: Decodable {
    let items: [GitHubRepository]
}

struct GitHubRepository: Decodable {
    let id: Int
    let fullName: String
    let description: String
    let stargazersCount: Int
    let url: String

    private enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case description
        case stargazersCount = "stargazers_count"
        case url = "html_url"
    }
}
