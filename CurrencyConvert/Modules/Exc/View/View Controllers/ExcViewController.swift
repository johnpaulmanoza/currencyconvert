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
}
