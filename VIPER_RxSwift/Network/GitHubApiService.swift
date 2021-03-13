//
//  GitHubApiService.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

import Foundation
import Alamofire
import Moya

enum GitHubApiService {
    case getSearch(query: String)
    case getDetail(id: String)
}

extension GitHubApiService: TargetType {
    var baseURL: URL {
        switch self {
        case .getSearch(let query):
            let q = query.isEmpty ? "swift": query
            return URL(string: "https://api.github.com/search/repositories?q=\(q)&l=swift")!
        case .getDetail(let id):
            return URL(string: " add url \(id)")!
        }
    }

    var path: String {
        return ""
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .getSearch:
            return .get
        case .getDetail:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }

    var parameters: [String : Any] {
        var parameters = [String:Any]()
        switch self {
        case .getSearch(let query):
            return parameters
        case .getDetail(let id):
            return parameters
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
