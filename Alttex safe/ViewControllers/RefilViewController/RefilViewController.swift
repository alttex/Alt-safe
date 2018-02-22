//
//  RefilViewController.swift
//  Alttex safe
//
//  Created by Vlad Kovryzhenko on 2/8/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import UIKit
import Moya
import RxCocoa
import RxSwift


class RefilViewController: UIViewController {
    
    
    @IBOutlet weak var coinTableView: UITableView!
    
    
    let disposeBag = DisposeBag()
    let viewModel = CurrencyViewModel()
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getCurrencies()
            .bind(to: coinTableView.rx.items(cellIdentifier: WalletsTableViewCell.Identifier, cellType: WalletsTableViewCell.self)) { index, model, cell in
                cell.currency = model
            }
            .disposed(by: self.disposeBag)
        
//        coinTableView.rx.modelSelected(Currency.self)
//            .subscribe(onNext: { currency in
//                self.performSegue(withIdentifier: "showDetails", sender: currency)
//            })
//            .disposed(by: disposeBag)
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//
//        switch (segue.identifier ?? "") {
//        case "showDetails":
//            if let detailsViewController = segue.destination as? DetailsViewController {
//                detailsViewController.present(de, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>) = sender as? Currency
//            }
//        default:
//            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
//        }
//    }
    
    
}
