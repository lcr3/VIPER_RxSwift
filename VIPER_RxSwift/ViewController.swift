//
//  ViewController.swift
//  
//
//  Created by lcr on 2021/03/09.
//  
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    @IBAction func searchButtonTouched(_ sender: Any) {
        let a = ListInteractor()
        a.fetch().subscribe { repo in
            print("success: \(repo.items.count)")

        } onError: { error in
            print("error: \(error)")
        } onCompleted: {
            print("complication")
        } onDisposed: {
            print("disposed")
        }

    }
}

