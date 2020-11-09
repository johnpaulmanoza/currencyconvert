//
//  WalletCell.swift
//  CurrencyConvert
//
//  Created by John Paul Manoza on 11/9/20.
//  Copyright © 2020 John Paul Manoza. All rights reserved.
//

import UIKit

class WalletCell: UITableViewCell {
    
    var data: WalletCellItem? {
        didSet {
            if let wallet = data?.wallet {
                textLabel?.text = "\(wallet.walletBalanceAmount)"
                detailTextLabel?.text = wallet.walletBalanceCurrency
            }
            
            if let balance = data?.balance {
                textLabel?.text = "\(balance.balanceAmount)"
                detailTextLabel?.text = balance.balanceCurrency
            }
        }
    }
}
