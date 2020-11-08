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
        let vm = ExcViewModel()
        let sellAmount = 100.0 // eur
        let rate = 1.18746 // eur to usd
        let convertedAmount = 118.746 // to receive in usd
        
        // when
        let sut = vm.convert(sellAmount: sellAmount, rate: rate)
        
        // then
        XCTAssertEqual(sut, convertedAmount)
    }
    
    func testConversionWithEndingBalance() {
        
        // given
        let vm = ExcViewModel()
        let initialBalance = 1000.0
        let sellAmount = 100.0 // eur
        let rate = 1.18746 // eur to usd
        let commissionRate = 0.7 // 0.7% Rate
        let endingBalance = 880.554 // ending balance in eur wallet
        
        // when
        let sut = vm.convertWithEndingBalance(sellAmount: sellAmount, rate: rate, commissionRate: commissionRate, balance: initialBalance)
        
        // then
        XCTAssertEqual(sut, endingBalance)
    }
}
