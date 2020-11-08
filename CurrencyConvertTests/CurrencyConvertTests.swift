//
//  CurrencyConvertTests.swift
//  CurrencyConvertTests
//
//  Created by John Paul Manoza on 11/7/20.
//  Copyright © 2020 John Paul Manoza. All rights reserved.
//

import XCTest
@testable import CurrencyConvert

class CurrencyConvertTests: XCTestCase {

    func testConversion() {
        
        // given
        let service = ExcService()
        let sellAmount = 100.0 // eur
        let rate = 1.18746 // eur to usd
        let convertedAmount = 118.746 // to receive in usd
        
        // when
        let sut = service.convert(sellAmount: sellAmount, rate: rate)
        
        // then
        XCTAssertEqual(sut, convertedAmount)
    }
    
    func testConversionWithCommission() {
        
        // given
        let service = ExcService()
        let sellAmount = 100.0 // eur
        let rate = 1.18746 // eur to usd
        let commissionRate = 0.7 // 0.7% Rate
        let convertedAmount = 119.446 // to receive in usd
        
        // when
        let sut = service.convertWithComission(sellAmount: sellAmount, rate: rate, commissionRate: commissionRate)
        
        // then
        XCTAssertEqual(sut, convertedAmount)
    }
}
