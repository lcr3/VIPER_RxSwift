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

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var dataSource: UICollectionViewDiffableDataSource<ListSection, GitHubRepository> = {
        let dataSouce = UICollectionViewDiffableDataSource<ListSection, GitHubRepository>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            let cell = UICollectionViewCell()
            cell.backgroundColor = .red
            return cell
        }
        return dataSouce
    }()

    var repositoryArray: [GitHubRepository] = [] {
        didSet{
            self.collectionView.reloadData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
//        presenter.searchRepositories()
    }
    

    @IBAction func buttonTouched(_ sender: Any) {
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("touched")
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositoryArray.count
    }

}


extension ListViewController: ListViewProtocol {
    func handlePresenterOutput(_ output: ListPresenterOutput) {
//        switch output {
//        case .showRepositories(let repositories):
//            self.pokemonArray = pokemonsArray
//        }
    }
}
