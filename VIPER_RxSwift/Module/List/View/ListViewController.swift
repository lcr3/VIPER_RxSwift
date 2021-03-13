//
//  ListViewController.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

import RxSwift
import RxCocoa
import UIKit

protocol ListViewProtocol: AnyObject {
}

class ListViewController: UIViewController, StoryboardInstantiatable {
    static var instantiateType: StoryboardInstantiateType { .initial }

    var presenter: ListPresenterProtocol!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // output通知を受け取る
        presenter.outputs.gitHubRepositories.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { _ in
                self.tableView.reloadData()
            }.disposed(by: disposeBag)

        // textFieldの変更をpresenterにinputとして送る
        textField.rx.text.orEmpty
            .filter { $0.count >= 2 }
            .debounce(DispatchTimeInterval.seconds(Int(0.5)), scheduler: MainScheduler.instance)
            .subscribe { text in
                self.presenter.inputs.inputSearchTrigger.onNext(text)
            }.disposed(by: disposeBag)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.outputs.gitHubRepositories.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repo = presenter.outputs.gitHubRepositories.value[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
        cell.textLabel?.text = "\(repo.fullName)"
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.detailTextLabel?.text = "\(repo.description)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.inputs.didSelectRowTrigger.onNext(indexPath)
    }
}

extension ListViewController: ListViewProtocol {
}
