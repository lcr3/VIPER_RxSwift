//
//  DetailRouter.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/11.
//  
//

import UIKit

protocol DetailRouterProtocol: AnyObject {
}

final class DetailRouter {
    private unowned let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    static func assembleModules(repo: GitHubRepository) -> UIViewController {
        let view = DetailViewController.instantiate()
        let router = DetailRouter(viewController: view)
        let presenter = DetailPresenter(view: view,
                                        router: router,
                                        repo: repo)
        view.presenter = presenter
        return view
    }
}

extension DetailRouter: DetailRouterProtocol {
}
