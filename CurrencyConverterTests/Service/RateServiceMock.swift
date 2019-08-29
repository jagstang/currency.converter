//
//  RateServiceMock.swift
//  CurrencyConverterTests
//
//  Created by Jag Stang on 23/01/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import Foundation

class RatesServiceMock: RatesServiceProtocol {
    
    private var rates: [String: [String: Float]]
    
    init(rates: [String: [String: Float]]) {
        self.rates = rates
    }
    
    func getRates(for baseCurrencyName: String, completion: @escaping ([String : Float]) -> ()) {
        var rates = self.rates[baseCurrencyName]!
        rates[baseCurrencyName] = 1.0
        completion(rates)
    }
}
