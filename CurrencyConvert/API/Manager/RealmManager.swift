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
        
        print("Realm path -->", config.fileURL?.absoluteString ?? "File can't found")
    }
}
