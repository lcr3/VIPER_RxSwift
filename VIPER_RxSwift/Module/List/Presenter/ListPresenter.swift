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
//    var mainModuleActionsSubject: PublishSubject<GitHubModuleActions> { get }
//    func performAction(_ action: GitHubModuleActions)
//    func searchRepositories()
    var inputs: ListPresenterInputs { get }
    var outputs: ListPresenterOutputs { get }
}

protocol ListPresenterInputs {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var didSelectRowTrigger: PublishSubject<IndexPath>  { get }
}

protocol ListPresenterOutputs {
//    var viewConfigure: Observable<ListEntryEntity> { get }
//    var isLoading: Observable<Bool> { get }
//    var error: Observable<NSError> { get }
        var gitHubRepositories: BehaviorRelay<[GitHubRepository]> { get }

}

final class ListPresenter {
    private let view: ListViewProtocol
    private let interactor: ListInteractorProtocol
    private let router: ListRouterProtocol
    private let disposeBag = DisposeBag()

    var inputs: ListPresenterInputs { return self }
    var outputs: ListPresenterOutputs { return self }

    // Inputs
    let viewDidLoadTrigger = PublishSubject<Void>()
    let didSelectRowTrigger = PublishSubject<IndexPath>()

    // Outputs
//    let gitHubRepositories = BehaviorSubject<[GitHubRepository]>(value: [])
    let gitHubRepositories = Variable<[GitHubRepository]>([])

    var mainModuleActionsSubject = PublishSubject<GitHubModuleActions>()

    init(view: ListViewProtocol, router: ListRouterProtocol, interactor: ListInteractorProtocol) {
        self.view = view
        self.router = router
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
                self.gitHubRepositories = repository
//                self.repositoriesArray = repository.items
            } onError: { error in
                // errorhandler
            }.disposed(by: disposeBag)
    }
}

extension ListPresenter: ListPresenterInputs {

}

extension ListPresenter: ListPresenterOutputs {

}
