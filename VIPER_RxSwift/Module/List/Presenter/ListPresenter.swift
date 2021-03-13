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

final class ListPresenter: ListPresenterProtocol, ListPresenterInputs, ListPresenterOutputs {
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

        didSelectRowTrigger.asObservable()
             .observeOn(MainScheduler.asyncInstance)
             .bind(onNext: transitionDetail)
             .disposed(by: disposeBag)

        inputSearchTrigger.asObservable()
            .subscribe { st in
                print("search text: \(st)")
                self.fetchList(text: st)
            } onError: { error in
                print("\(error)")
            }.disposed(by: disposeBag)

        // firstRequest
        fetchList(text: "")
    }

    private func fetchList(text: String) {
        interactor.fetchList(query: text, page: 0)
            .subscribeOn(MainScheduler.instance)
            .subscribe { result in
                switch result {
                case let .success(response):
                    self.gitHubRepositories.accept(response.items)
                print(response)
                case .failure:
                    print("error")
                }
            } onError: { error in
                // error handler
            }
    }

    private func transitionDetail(indexPath: IndexPath) {
        let repo = gitHubRepositories.value[indexPath.row]
        router.showDetail(repo: repo)
    }
}
