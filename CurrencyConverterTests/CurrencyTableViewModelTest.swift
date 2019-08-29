//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Jag Stang on 22/01/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class CurrencyTableViewModelTests: XCTestCase {
    
    let rates: [String: [String: Float]] = [
        "EUR": ["RUB": 40, "USD": 1.16],
        "USD": ["RUB": 32, "USD": 0.8],
        "RUB": ["EUR": 0.022, "USD": 0.031],
    ]
    
    var viewModel: CurrencyTableViewModel!
    
    func testInitCells() {
        viewModel = createViewMode()
        viewModel.initCells {
            XCTAssertEqual(self.viewModel.getCellsCount(), 3, "CurrencyTableViewModel cells count doesn't equals to rates count")
        }
    }
    
    func testMakeBase() {
        viewModel = createViewMode()
        viewModel.initCells {}
        
        let cells = getCurrenciesNamesFromCells()
        XCTAssertEqual(cells[0], "EUR", "CurrencyTableViewModel cells must be in alphabet order after init")
        XCTAssertEqual(cells[1], "RUB", "CurrencyTableViewModel cells must be in alphabet order after init")
        
        viewModel.makeBase(row: 1)
        
        let cellsAfterMove = getCurrenciesNamesFromCells()
        XCTAssertEqual(cellsAfterMove[0], "RUB", "CurrencyTableViewModel cells must be swapped after makeBase")
        XCTAssertEqual(cellsAfterMove[1], "EUR", "CurrencyTableViewModel cells must be swapped after makeBase")
        
        XCTAssertEqual(viewModel.baseCurrencyName, "RUB", "CurrencyTableViewModel baseCurrencyName must be equal to first cell currency name")
    }
    
    func testUpdateBaseValue() {
        viewModel = createViewMode()
        viewModel.initCells {}
        let cells = getCurrenciesNamesFromCells()
        
        viewModel.makeBase(row: cells.firstIndex(of: "EUR")!)
        let rubCell = viewModel.getCellViewModel(at: cells.firstIndex(of: "RUB")!)
        let usdCell = viewModel.getCellViewModel(at: cells.firstIndex(of: "USD")!)
        
        viewModel.updateBaseValue(value: 100)
        XCTAssertEqual(rubCell.currency.value, 4000)
        XCTAssertEqual(usdCell.currency.value, 116)
        
        viewModel.updateBaseValue(value: 50)
        XCTAssertEqual(rubCell.currency.value, 2000)
        XCTAssertEqual(usdCell.currency.value, 58)
        
        viewModel.makeBase(row: cells.firstIndex(of: "RUB")!)
        viewModel.updateBaseValue(value: 100)
        XCTAssertEqual(usdCell.currency.value, 3.1)
    }
    
    private func createViewMode() -> CurrencyTableViewModel {
        return CurrencyTableViewModel(
            converter: Converter(),
            service: RatesServiceMock(rates: rates)
        )
    }
    
    private func getCurrenciesNamesFromCells() -> [String] {
        var cells: [String] = []
        for i in 0..<viewModel.getCellsCount() {
            cells.append(viewModel.getCellViewModel(at: i).currency.name)
        }
        return cells
    }
}
