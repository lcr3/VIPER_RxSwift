//
//  ListViewController.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

import RxSwift
import UIKit

protocol ListViewProtocol: AnyObject {
    func handlePresenterOutput(_ output: ListPresenterOutput)
}

enum ListSection: Int, CaseIterable {
    case list
}

class ListViewController: UIViewController, StoryboardInstantiatable {
    static var instantiateType: StoryboardInstantiateType { .initial }

    var presenter: ListPresenterProtocol!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var repositoryArray: [GitHubRepository] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        presenter.outputs.gitHubRepositories.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { _ in
                print("リロード")
                self.tableView.reloadData()
            }.disposed(by: disposeBag)

    }

    @IBAction func buttonTouched(_ sender: Any) {
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
