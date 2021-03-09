//
//  ListViewController.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

import UIKit

protocol ListViewProtocol {
    func handlePresenterOutput(_ output: ListPresenterOutput)
}

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListViewController: ListViewProtocol {
    func handlePresenterOutput(_ output: ListPresenterOutput) {
//        switch output {
//        case .showRepositories(let repositories):
//            self.pokemonArray = pokemonsArray
//        }
    }
}
