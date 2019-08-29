//
//  ConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Jag Stang on 16/03/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class ConverterTests: XCTestCase {
    
    let rates: [String: [String: Float]] = [
        "EUR": ["RUB": 40, "USD": 1.16, "EUR": 1.0],
        "RUB": ["EUR": 0.022, "USD": 0.031, "RUB": 1.0],
    ]
    
    func testConvert() {
        let converter = Converter()
        
        converter.update(rates: rates["EUR"]!)
        XCTAssertEqual(converter.convert(value: 1.0, to: "RUB"), 40)
        XCTAssertEqual(converter.convert(value: 2.0, to: "RUB"), 80)
        XCTAssertEqual(converter.convert(value: 2.0, to: "USD"), 2.32)
        
        converter.update(rates: rates["RUB"]!)
        XCTAssertEqual(converter.convert(value: 80.0, to: "EUR"), 1.76)
        XCTAssertEqual(converter.convert(value: 100.0, to: "USD"), 3.1)
        
        XCTAssertEqual(converter.convert(value: 50.0, to: "RUB"), 50.0)
        
        XCTAssertEqual(converter.convert(value: 100.0, to: "SOMETHING_WRONG"), 0)
    }
}
