//
//  ListPresenter.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

import Foundation
import RxSwift
import RxRelay

protocol ListPresenterProtocol: AnyObject {
    var inputs: ListPresenterInputs { get }
    var outputs: ListPresenterOutputs { get }
}

protocol ListPresenterInputs {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var didSelectRowTrigger: PublishSubject<IndexPath>  { get }
}

protocol ListPresenterOutputs {
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
    let gitHubRepositories = BehaviorRelay<[GitHubRepository]>(value: [])

    init(view: ListViewProtocol, router: ListRouterProtocol, interactor: ListInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor

        self.interactor.fetch()
            .subscribe { repository in
                self.gitHubRepositories.accept(repository.items)
            } onError: { error in
                // errorhandler
            }.disposed(by: disposeBag)

    }
}

extension ListPresenter: ListPresenterProtocol {
    func searchRepositories() {
    }
}

extension ListPresenter: ListPresenterInputs {

}

extension ListPresenter: ListPresenterOutputs {

}
