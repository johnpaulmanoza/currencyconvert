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
    var sections: PublishSubject<[ExcListItem]> = PublishSubject()
    var isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var successConversion: PublishSubject<(String, String, String?)> = PublishSubject()
    var errorConversion: PublishSubject<String?> = PublishSubject()
    var error: PublishSubject<String?> = PublishSubject()
    
    // MARK: Private
    private let excService = ExcService()
    private let bag = DisposeBag()
    
    init() {
        
        loadLatestExchangeRates()
        
        // run on main thread and make sure to add delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak this = self] in
           this?.showItems()
        }
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
    Start the computation
     
     - Parameters:
        - amount: amount to convert
     */
    func commitConversion(amount: Double) {
        
        excService.commitConversion(amount: amount) { [weak this = self] (amountDesc, convertedDesc, commissionDesc, error) in
            
            // show an error if an error occured
            guard error == nil else { this?.errorConversion.onNext(error!); return }
            
            // show success dialog when there is no error
            guard let amountDesc = amountDesc else { return }
            guard let convertedDesc = convertedDesc else { return }
            this?.successConversion.onNext((amountDesc, convertedDesc, commissionDesc))
            
            // reload table to display updated data
            this?.showItems(fromAmount: amountDesc, toAmount: convertedDesc)
        }
    }
    
    /**
     
    Display list items by iterating the currency results and converting them to UI Model Classes
     
     */
    func showItems(fromAmount: String? = nil, toAmount: String? = nil) {
        
        // formatter for displayed values
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        // extract values from selection
        let wallet = excService.currentWallet()
        
        let balanceDesc = formatter.string(from: (wallet?.walletBalanceAmount ?? 0) as NSNumber) ?? ""
        let currentBalance = "\(balanceDesc) \(wallet?.walletBalanceCurrency ?? "")"
        let fromCurrencySymbol = "\(wallet?.walletBalanceCurrency ?? "")"
        
        let currentCurrency = excService.selectedCurrency()
        let toCurrencySymbol = "\(currentCurrency?.currencySymbol ?? "")"
        
        // remove symbols to display the bare amount
        let fromValue: String? = fromAmount == nil ? nil : fromAmount!.replacingOccurrences(of: " \(fromCurrencySymbol)", with: "")
        let toValue: String? = toAmount == nil ? nil : toAmount!.replacingOccurrences(of: " \(toCurrencySymbol)", with: "")
        
        // create cell data
        let listItem = ExcCellItem(currentBalance: currentBalance, fromCurrencySymbol: fromCurrencySymbol, toCurrencySymbol: toCurrencySymbol, fromValue: fromValue, toValue: toValue)
        
        // display the cell
        sections.onNext([
            ExcListItem.listSection(header: "", items: [
                ExcListItem.Row.excItem(item: listItem)
            ])
        ])
    }
}
