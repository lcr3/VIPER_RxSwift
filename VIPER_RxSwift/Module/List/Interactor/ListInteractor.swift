//
//  ListInteractor.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

import Foundation
import Moya
import RxSwift

enum ListInteractorError: Error {
    case dataNil
}

protocol ListInteractorProtocol {
    func fetchList(query: String, page: Int) -> Single<Result<SearchRepositoriesResponse, Error>>
}

final class ListInteractor {

    private(set) var disposeBag = DisposeBag()
    let moyaProvider = MoyaProvider<GitHubApiService>(plugins: [NetworkLoggerPlugin()])

    init() {
    }
}


extension ListInteractor: ListInteractorProtocol {
    func fetchList(query: String, page: Int) -> Single<Result<SearchRepositoriesResponse, Error>> {
        return Single.create { observer in
            DispatchQueue.main.async {
                self.moyaProvider.request(GitHubApiService.getSearch(query: query)) { result in
                    switch result {
                    case .success(let response):
                        guard let serchResponse = try? JSONDecoder().decode(SearchRepositoriesResponse.self, from: response.data) else {
                            observer(.success((Result.success(SearchRepositoriesResponse(items: [])))))
                            return
                        }
                        observer(.success((Result.success(serchResponse))))
                    case .failure(let error):
                        observer(.error(error))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
