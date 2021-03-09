//
//  ListPresenterOutput.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

enum ListPresenterOutput {
    case showRepositories([GitHubRepository])
}

enum GitHubModuleActions {
    case showDetail(id: String)
    case showMoves
}
