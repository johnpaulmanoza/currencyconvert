//
//  ExcRate.swift
//  CurrencyConvert
//
//  Created by John Paul Manoza on 11/8/20.
//  Copyright © 2020 John Paul Manoza. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

// NOTE: This class serves two purposes, to map the response
// and to create a new schema for the local database object

public class ExcRate: Object, Mappable {

    @objc dynamic public var exchangeRateDate: String = ""
    @objc dynamic public var exchangeRateBase: String = ""
    
    // Don't map these values
    public var exchangeRateCAD: Double = 0.0
    public var exchangeRateAUD: Double = 0.0
    public var exchangeRateJPY: Double = 0.0
    public var exchangeRateUSD: Double = 0.0
    public var exchangeRatePHP: Double = 0.0
    public var exchangeRateGBP: Double = 0.0

    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        
        exchangeRateDate    <- map["date"]
        exchangeRateBase    <- map["base"]
        
        exchangeRateCAD     <- map["rates.CAD"]
        exchangeRateAUD     <- map["rates.AUD"]
        exchangeRateJPY     <- map["rates.JPY"]
        exchangeRateUSD     <- map["rates.USD"]
        exchangeRatePHP     <- map["rates.PHP"]
        exchangeRateGBP     <- map["rates.GBP"]
    }

    public override class func primaryKey() -> String {
        return "exchangeRateDate"
    }
}

public class Currency: Object, Mappable {

    @objc dynamic public var currencySymbol: String = ""
    @objc dynamic public var currencyRate: Double = 0.0
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        
        currencySymbol  <- map["symbol"]
        currencyRate    <- map["rate"]
    }
    
    public override class func primaryKey() -> String {
        return "currencySymbol"
    }
}
