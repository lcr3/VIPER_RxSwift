//
//  DetailViewController.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/11.
//  
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    func set(title: String)
    func set(description: String)
}

class DetailViewController: UIViewController, StoryboardInstantiatable {
    static var instantiateType: StoryboardInstantiateType { .initial }
    var presenter: DetailPresenterProtocol!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension DetailViewController: DetailViewProtocol {
    func set(title: String) {
        titleLabel.text = title
    }

    func set(description: String) {
        descriptionView.text = description
    }
}
