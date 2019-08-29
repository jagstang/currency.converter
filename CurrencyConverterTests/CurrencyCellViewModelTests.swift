//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Jag Stang on 22/01/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class CurrencyCellViewModelTests: XCTestCase {

    var viewModel: CurrencyCellViewModel!
    
    func testOutputValue() {
        viewModel = CurrencyCellViewModel(with: Currency(name: "", value: 0.5555))
        XCTAssertEqual(viewModel.value, "0.56", "CurrencyCellViewModel doesn't round value up")
        
        viewModel = CurrencyCellViewModel(with: Currency(name: "", value: 0.5315))
        XCTAssertEqual(viewModel.value, "0.53", "CurrencyCellViewModel doesn't round value down")
        
        viewModel = CurrencyCellViewModel(with: Currency(name: "", value: 423))
        XCTAssertEqual(viewModel.value, "423", "CurrencyCellViewModel doesn't round value correctly")
        
        viewModel = CurrencyCellViewModel(with: Currency(name: "", value: nil))
        XCTAssertEqual(viewModel.value, "", "CurrencyCellViewModel doesn't show empty string")
    }
    
    func testInputValue() {
        viewModel = CurrencyCellViewModel(with: Currency(name: "", value: nil))
        XCTAssertTrue(viewModel.validateInputValue("1"), "CurrencyCellViewModel doesn't pass small int value")
        XCTAssertTrue(viewModel.validateInputValue("1234"), "CurrencyCellViewModel doesn't pass int value")
        XCTAssertTrue(viewModel.validateInputValue("0.50"), "CurrencyCellViewModel doesn't pass float value less than one")
        XCTAssertTrue(viewModel.validateInputValue("1.50"), "CurrencyCellViewModel doesn't pass float value")
        XCTAssertTrue(viewModel.validateInputValue("1123.01"), "CurrencyCellViewModel doesn't pass float value")
        
        XCTAssertFalse(viewModel.validateInputValue("1123.01234"), "CurrencyCellViewModel pass float value with long fractional part")
        XCTAssertFalse(viewModel.validateInputValue("1123.012.34"), "CurrencyCellViewModel pass string with more than 1 float separator")
    }
}
