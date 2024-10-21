//
//  Double + Ext.swift
//  Crypto App
//
//  Created by Phat Vuong Vinh on 20/10/24.
//

import Foundation

extension Double {
    func convertDoubleToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.currencySymbol = "$"
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? ""
        
    }
}
