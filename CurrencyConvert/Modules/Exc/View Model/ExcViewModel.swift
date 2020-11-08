//
//  ExcViewModel.swift
//  CurrencyConvert
//
//  Created by John Paul Manoza on 11/8/20.
//  Copyright © 2020 John Paul Manoza. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

public class ExcViewModel {
    
    // MARK: Public
    var isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var error: PublishSubject<String?> = PublishSubject()
    
    // MARK: Private
    private let excService = ExcService()
    private let bag = DisposeBag()
    
    init() {
        
        loadLatestExchangeRates()
    }
    
    
    /**
        
    Load latest exchange rates and populate local db
     
    */
    func loadLatestExchangeRates() {
        
        isLoading.onNext(true)
        
        _ = excService.loadLatestExchangeRates()
            .subscribe(onNext: { [weak this = self] (item) in
                guard let this = this else { return }
                
                // hide loader
                this.isLoading.onNext(false)
                
            }, onError: { [weak this = self] (e) in
                
                // Display any errors
                this?.isLoading.onNext(false)
                this?.error.onNext(e.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    func startConversion(amount: Double) {
        
        guard let currentRate = excService.selectedCurrencyRate() else { return }
        
        let convertedValue = excService.convert(sellAmount: amount, rate: currentRate)
        
        
    }
}
