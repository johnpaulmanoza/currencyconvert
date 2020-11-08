//
//  UIViewController.swift
//  CurrencyConvert
//
//  Created by John Paul Manoza on 11/8/20.
//  Copyright © 2020 John Paul Manoza. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     To easily identify view by their id
    */
    public static var id: String {
        return String(describing: self)
    }
    
    /**
     To easily display a prompt or alert view
    */
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (_) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
