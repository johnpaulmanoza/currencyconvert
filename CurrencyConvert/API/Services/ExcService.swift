//
//  ExcService.swift
//  CurrencyConvert
//
//  Created by John Paul Manoza on 11/8/20.
//  Copyright © 2020 John Paul Manoza. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

public class ExcService {
    
    private let manager = APIManager()

    init() {
       
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
    
    /**
     
    Load latest exchange rates from the API
     
     */
    func loadLatestExchangeRates() -> Observable<Any> {
        return manager
            .requestObject(ExcRouter.loadExchangeRates, ExcRate.self)
            .map({ [weak this = self] (items) -> Any in
                guard let rates = items as? ExcRate else { return items }

                // store results to local database first
                this?.storeExcRate(item: rates)
                
                return items
            })
            .asObservable()
    }

    /**
     
    Persist exchange rates into local database
     
     - Parameters:
        - item: object to store
    */
    private func storeExcRate(item: ExcRate) {
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.create(ExcRate.self, value: item, update: .all)
            }
            
            // seed currency objects
            let values = [item.exchangeRateAUD,
                          item.exchangeRateCAD,
                          item.exchangeRateJPY,
                          item.exchangeRateUSD,
                          item.exchangeRatePHP,
                          item.exchangeRateGBP]
            
            let indices = ["AUD",
                           "CAD",
                           "JPY",
                           "USD",
                           "PHP",
                           "GBP"]
        
            _ = try zip(values, indices)
                .map { (value, key) -> Void in
                    
                    guard
                        let currency = realm.objects(Currency.self).filter("currencySymbol == '\(key)'").first
                    else
                        { return }
                    
                    // update currency
                    try realm.write {
                        currency.currencyRate = value
                    }
                }
            
            // seed wallet object if has no value
            if realm.objects(Wallet.self).count == 0 {
                let initialWallet = Wallet()
                initialWallet.walletBalanceCurrency = "EUR"
                initialWallet.walletId = 1 // user id is preferred
                try realm.write {
                    initialWallet.walletBalanceAmount = 1000.0 // initial balance of 1000 EUR
                    realm.create(Wallet.self, value: initialWallet, update: .all)
                }
            }
            
        } catch _ {

        }
    }
    
    /**
        
     Reset delivery items table
     
     */
    private func resetExcRateItems() {
        
        do {
            let realm = try Realm()
            try realm.write {
                let items = realm.objects(ExcRate.self); realm.delete(items)
            }
        } catch _ {

        }
    }
    
    /**
     
    Store the selected currency for conversion
     
    - Parameters:
     - currencySymbol: Selected currency symbol
     
     */
    func storeSelectedCurrency(currencySymbol: String) {
        
        do {
            
            let realm = try Realm()
            
            let currencies = realm.objects(Currency.self)
            
            guard
                let selectedCurrency = currencies.filter("currencySymbol == '\(currencySymbol)'").first
            else
                { return }
            
            // remove previous selections
            _ = try currencies.map({ (item) -> Void in
                try realm.write {
                    item.currencyIsSelected = false
                }
            })
            
            // set current selection
            try realm.write {
                selectedCurrency.currencyIsSelected = true
            }
            
        } catch _ {

        }
    }
    
    /**
     
    Get currency rate of selected currency
     
     */
    func selectedCurrencyRate() -> Double? {
        
        do {
            
            let realm = try Realm()
            let currencies = realm.objects(Currency.self)
            
            guard
                let selectedCurrency = currencies.filter("currencySymbol == true").first
            else
                { return nil }
            
            return selectedCurrency.currencyRate
            
        } catch _ {

            return nil
        }
    }
    
    func commitConversion(value: )
}
