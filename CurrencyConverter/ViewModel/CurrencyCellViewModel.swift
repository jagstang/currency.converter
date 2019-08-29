//
//  CurrencyCellViewModel.swift
//  CurrencyConverter
//
//  Created by Jag Stang on 22/01/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

class CurrencyCellViewModel {
    
    public var currency: Currency
    
    public var name: String {
        get {
            return currency.name
        }
    }
    
    public var value: String {
        get {
            if let value = currency.value {
                return trancateToString(value: value)
            } else {
                return ""
            }
        }
    }
    
    init(with currency: Currency) {
        self.currency = currency
    }
    
    public func updateCurrencyValue(value: Float?) {
        self.currency.value = value
    }
    
    public func validateInputValue(_ string: String) -> Bool {
        let range = string.range(of: "^[0-9]+[.,]?[0-9]{0,2}$", options: .regularExpression, range: nil, locale: nil)
        
        return string == "" || range != nil
    }
    
    private func trancateToString(value: Float) -> String {
        let result = (value * 100).rounded() / 100
        
        return result.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", result) : String(result)
    }
}
