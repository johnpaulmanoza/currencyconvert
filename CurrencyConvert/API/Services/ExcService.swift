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
    private let realm: Realm!
    
    init() {
        realm = try? Realm()
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
            try realm.write {
                realm.create(ExcRate.self, value: item, update: .all)
            }
        } catch _ {

        }
    }
    
    /**
        
     Reset delivery items table
     
     */
    private func resetExcRateItems() {
        
        do {
            try realm.write {
                let items = realm.objects(ExcRate.self); realm.delete(items)
            }
        } catch _ {

        }
    }
}
