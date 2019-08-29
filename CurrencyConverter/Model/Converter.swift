//
//  Converter.swift
//  CurrencyConverter
//
//  Created by Jag Stang on 22/01/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

class Converter {
    
    private var rates: [String: Float] = [:]
    
    public func update(rates: [String: Float]) {
        self.rates = rates
    }
    
    public func convert(value: Float, to currencyName: String) -> Float {
        guard let rate = rates[currencyName] else {
            return 0
        }
        
        return value * rate
    }
}
