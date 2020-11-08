//
//  ExcViewModel.swift
//  CurrencyConvert
//
//  Created by John Paul Manoza on 11/8/20.
//  Copyright © 2020 John Paul Manoza. All rights reserved.
//

import Foundation
import RxSwift

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
    
    /**
     
    Convert currency
    
    - Parameters:
     - sellAmount: amounth to convert
     - rate: conversion rate
 
    - Returns:
     - Converted amount
     
    */
    func convert(sellAmount: Double, rate: Double) -> Double {
        return sellAmount * rate
    }
    
    /**
     
    Convert currency with commission rate
     
    - Parameters:
     - sellAmount: amounth to convert
     - rate: conversion rate
     - commissionRate: charge for conversion (should be in percentage, e.g. if 7% etc)
     - balance: remaining balance in the account
     
    - Returns:
     - ending balance with the deducted amount converted and commission
     
     */
    func convertWithEndingBalance(sellAmount: Double, rate: Double, commissionRate: Double, balance: Double) -> Double {
        let conversion = convert(sellAmount: sellAmount, rate: rate)
        let commissionFee = (commissionRate / 100) * sellAmount
        return balance - (conversion + commissionFee)
    }
}
