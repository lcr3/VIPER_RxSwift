//
//  ListModuleRouter.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

import Foundation
import UIKit

protocol ListRouterProtocol: AnyObject {
    func showDetail(id: String)
}

final class ListRouter {
    private unowned let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    static func assembleModules() -> UIViewController {
        let view = ListViewController.instantiate()
        let router = ListRouter(viewController: view)
        let interector = ListInteractor()
        let presenter = ListPresenter(view: view,
                                          router: router,
                                          interactor: interector)
        view.presenter = presenter
        return view
    }
}

extension ListRouter: ListRouterProtocol {
    func showDetail(id: String) {
    }
}
