//
//  ExcViewModel.swift
//  CurrencyConvert
//
//  Created by John Paul Manoza on 11/8/20.
//  Copyright © 2020 John Paul Manoza. All rights reserved.
//

import Foundation

public class ExcViewModel {
    
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
