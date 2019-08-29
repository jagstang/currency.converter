//
//  CurrencyTableViewModel.swift
//  CurrencyConverter
//
//  Created by Jag Stang on 22/01/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class CurrencyTableViewModel {
    
    public let baseRow = 0
    
    private var cells: [CurrencyCellViewModel] = []
    private var service: RatesServiceProtocol
    private var converter: Converter
    private(set) var baseCurrencyName = "EUR"
    private(set) var baseCurrencyValue: Float?

    init(converter: Converter, service: RatesServiceProtocol) {
        self.converter = converter
        self.service = service
    }
    
    public func getCellsCount() -> Int {
        return cells.count
    }
    
    public func getCellViewModel(at row: Int) -> CurrencyCellViewModel {
        return cells[row]
    }
    
    public func initCells(completion: @escaping () -> ()) {
        service.getRates(
            for: baseCurrencyName,
            completion: { [weak self] (rates: [String: Float]) in
                guard let self = self else { return }
                
                self.converter.update(rates: rates)
                for name in rates.keys.sorted() {
                    let currency = Currency(name: name, value: nil)
                    self.cells.append(CurrencyCellViewModel(with: currency))
                }
                completion()
            }
        )
    }
    
    public func makeBase(row: Int) {
        cells = rearrange(array: cells, fromIndex: row, toIndex: baseRow)
        baseCurrencyName = cells[baseRow].currency.name
        baseCurrencyValue = cells[baseRow].currency.value
        service.getRates(
            for: baseCurrencyName,
            completion: { [weak self] (rates: [String: Float]) in
                guard let self = self else { return }
                
                self.converter.update(rates: rates)
            }
        )
    }
    
    public func updateBaseValue(value: Float?) {
        baseCurrencyValue = value
        updateCurrencyValues()
    }
    
    public func updateConverter(completion: @escaping () -> ()) {
        service.getRates(
            for: baseCurrencyName,
            completion: { [weak self] (rates: [String: Float]) in
                guard let self = self else { return }
                
                self.converter.update(rates: rates)
                self.updateCurrencyValues()
                completion()
            }
        )
    }
    
    private func updateCurrencyValues() {
        for cell in cells {
            if cell.currency.name != baseCurrencyName {
                if let base = baseCurrencyValue {
                    cell.updateCurrencyValue(value: converter.convert(value: base, to: cell.name))
                } else {
                    cell.updateCurrencyValue(value: nil)
                }
            }
        }
    }
    
    private func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T>{
        var arr = array
        let element = arr.remove(at: fromIndex)
        arr.insert(element, at: toIndex)
        
        return arr
    }
}
