//
//  ListPresenter.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

import Foundation
import RxSwift

protocol ListPresenterProtocol: AnyObject {
    var mainModuleActionsSubject: PublishSubject<GitHubModuleActions> { get }
    func performAction(_ action: GitHubModuleActions)
    func searchRepositories()
}

final class ListPresenter {

    private let view: ListViewProtocol
    private let interactor: ListInteractorProtocol
    private let disposeBag = DisposeBag()
    var mainModuleActionsSubject = PublishSubject<GitHubModuleActions>()

    init(view: ListViewProtocol, interactor: ListInteractorProtocol) {
        self.view = view
        self.interactor = interactor

        mainModuleActionsSubject.subscribe { (moduleAction) in
            self.performAction(moduleAction)
        }.disposed(by: disposeBag)
    }

    private var repositoriesArray = [GitHubRepository]() {
        didSet {
            view.handlePresenterOutput(.showRepositories(repositoriesArray))
        }
    }


    func performAction(_ action: GitHubModuleActions) {
        print("viewからのactionを通知")
    }
}

extension ListPresenter: ListPresenterProtocol {
    func searchRepositories() {
        interactor.fetch()
            .subscribe { repository in
                self.repositoriesArray = repository.items
            } onError: { error in
                // errorhandler
            }.disposed(by: disposeBag)
    }
}
