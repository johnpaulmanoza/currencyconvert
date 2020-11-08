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
            
            // update rate from currency object
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
}
