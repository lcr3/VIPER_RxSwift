//
//  DetailPresenter.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/11.
//  
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    var repo: GitHubRepository { get }
    func viewDidLoad()
}

final class DetailPresenter {
    private let view: DetailViewProtocol
    private let router: DetailRouterProtocol
    internal var repo: GitHubRepository

    init(view: DetailViewProtocol,
         router: DetailRouterProtocol,
         repo :GitHubRepository) {
        self.view = view
        self.router = router
        self.repo = repo
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        view.set(title: repo.fullName)
        view.set(description: repo.description)
    }
}
