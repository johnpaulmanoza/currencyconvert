//
//  RealmManager.swift
//  CurrencyConvert
//
//  Created by John Paul Manoza on 11/8/20.
//  Copyright © 2020 John Paul Manoza. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {

    init() {
        
    }

    convenience init(mockedRealm: Realm) {
        self.init()
    }
    
    // Set initial schema version, useful for migration later
    private func schemaVersion() -> UInt64 {
        return 1
    }
    
    public func config() {
        
        let config = Realm.Configuration(schemaVersion: schemaVersion(), migrationBlock: { migration, oldSchemaVersion in })
        Realm.Configuration.defaultConfiguration = config
        
        // seed initial data
        seedData()
        
        print("Realm path -->", config.fileURL?.absoluteString ?? "File can't found")
    }
    
    public func seedData() {
        
        let symbols = ["CAD", "AUD", "JPY", "USD", "PHP", "GBP"]
        
        do {
            let realm = try Realm()
            
            let items = symbols
                .map({ (symbol) -> Currency in
                    let item = Currency()
                    item.currencySymbol = symbol
                    return item
                })
            
            try realm.write {
                _ = items.map { realm.create(Currency.self, value: $0, update: .all) }
            }
            
        } catch _ {

        }
    }
}
