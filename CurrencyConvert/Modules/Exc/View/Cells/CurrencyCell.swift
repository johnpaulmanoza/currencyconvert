//
//  CurrencyCell.swift
//  CurrencyConvert
//
//  Created by John Paul Manoza on 11/8/20.
//  Copyright © 2020 John Paul Manoza. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    public var data: CurrencyCellItem? {
        didSet {
            guard let currency = data?.currency else { return }
            textLabel?.text = currency.currencySymbol
            detailTextLabel?.text = "\(currency.currencyRate)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
