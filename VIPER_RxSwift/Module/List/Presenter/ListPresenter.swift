//
//  ListPresenter.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

protocol ListPresenterProtocol: AnyObject {
    var inputs: ListPresenterInputs { get }
    var outputs: ListPresenterOutputs { get }
}

protocol ListPresenterInputs {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var didSelectRowTrigger: PublishSubject<IndexPath> { get }
    var inputSearchTrigger: PublishSubject<String> { get }
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
    let inputSearchTrigger = PublishSubject<String>()

    // Outputs
    let gitHubRepositories = BehaviorRelay<[GitHubRepository]>(value: [])

    init(view: ListViewProtocol, router: ListRouterProtocol, interactor: ListInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor

        interactor.fetch()
            .subscribe { repository in
                self.gitHubRepositories.accept(repository.items)
            } onError: { error in
                // errorhandler
            }.disposed(by: disposeBag)

        didSelectRowTrigger.asObservable()
             .observeOn(MainScheduler.asyncInstance)
             .bind(onNext: transitionDetail)
             .disposed(by: disposeBag)

        inputSearchTrigger.asObservable()
            .subscribe { st in
                print("next: \(st)")

            } onError: { error in
                print("\(error)")
            } onCompleted: {
                print("onComplted")
            }.disposed(by: disposeBag)
    }

    private func transitionDetail(indexPath: IndexPath) {
        let repo = gitHubRepositories.value[indexPath.row]
        router.showDetail(repo: repo)
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
