//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Jag Stang on 22/01/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

class Currency {
    
    var name: String
    var value: Float?
    
    init(name: String, value: Float?) {
        self.name = name
        self.value = value
    }
}
