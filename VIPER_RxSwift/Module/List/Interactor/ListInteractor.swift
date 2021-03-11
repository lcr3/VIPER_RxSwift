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

protocol ListInteractorProtocol {
    func fetch() -> Observable<SearchRepositoriesResponse>
}

final class ListInteractor {

    private(set) var disposeBag = DisposeBag()
    let moyaProvider = MoyaProvider<GitHubApiService>(plugins: [NetworkLoggerPlugin()])

    init() {}
}


extension ListInteractor: ListInteractorProtocol {
    func fetch() -> Observable<SearchRepositoriesResponse> {
        return moyaProvider.rx.request(GitHubApiService.getSearch)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { response in
                guard let serchResponse = try? JSONDecoder().decode(SearchRepositoriesResponse.self, from: response.data) else {
                    return SearchRepositoriesResponse(items: [])
                }
                return serchResponse
            }
    }
}
