//
//  ExcViewController.swift
//  CurrencyConvert
//
//  Created by John Paul Manoza on 11/8/20.
//  Copyright © 2020 John Paul Manoza. All rights reserved.
//

import UIKit
import RxSwift
import JGProgressHUD

class ExcViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ExcViewModel()
    private let loading = JGProgressHUD(style: .dark)
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        customize()
        
        bind()
        
        observe()
    }
    
    private func customize() {
        
    }
    
    private func bind() {
        
        tableView.dataSource = self
    }
    
    private func observe() {
        
        // Update Loader Status
        _ = viewModel.isLoading.asObservable()
            .subscribe(onNext: { [weak this = self] (isloading) in
                guard let this = this else { return }
                _ = isloading
                    ? this.loading.show(in: this.view)
                    : this.loading.dismiss(animated: true)
            })
            .disposed(by: bag)
        
        // Show an error once view model throws one
        _ = viewModel.error.asObservable()
            .subscribe(onNext: { [weak this = self] (error) in
                guard let errorMsg = error else { return }
                this?.presentAlertWithTitle(title: Vocabulary.ErrorNetworkRequest,
                                            message: errorMsg,
                                            options: Vocabulary.Retry,
                                            completion: { _ in
                                                this?.viewModel.loadLatestExchangeRates()
                                            })
            })
            .disposed(by: bag)
    }
    
    @IBAction func tapSubmitButton(_ sender: Any) {
        
        viewModel.commitConversion(amount: 120)
    }
    
    private func navigateToCurrencyList() {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let nav = board.instantiateViewController(withIdentifier: CurrencyViewController.navId)
        present(nav, animated: true, completion: nil)
    }
}

extension ExcViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversionCell.id, for: indexPath) as? ConversionCell else {
            return UITableViewCell()
        }
        
        observeCell(cell)
        
        return cell
    }
    
    public func observeCell(_ type: AnyObject) {

        if let cell = type as? ConversionCell {

            _ = cell.toCurrencyButton.rx.tap.asObservable()
                .subscribe(onNext: { [weak this = self] (_) in
                    this?.navigateToCurrencyList()
                })
                .disposed(by: cell.bag)
        }
    }
}
