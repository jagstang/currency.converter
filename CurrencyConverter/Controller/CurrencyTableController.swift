//
//  CurrencyTableController.swift
//  CurrencyConverter
//
//  Created by Jag Stang on 22/01/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class CurrencyTableController: UITableViewController {

    let CELL_IDENTIFIER = "currencyCell"
    
    private var viewModel = CurrencyTableViewModel(converter: Converter(), service: RatesService())
    private let timerInterval: Double = 1
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.keyboardDismissMode = .onDrag
        
        viewModel.initCells { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.startTimer()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.stopTimer()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCellsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as! CurrencyCell

        cell.configure(with: viewModel.getCellViewModel(at: indexPath.row))
        cell.delegate = self
        
        return cell
    }
    
    private func updateCells() {
        if var rowsForUpdate = tableView.indexPathsForVisibleRows {
            if let i = rowsForUpdate.firstIndex(of: IndexPath(row: viewModel.baseRow, section: 0)) {
                rowsForUpdate.remove(at: i)
            }
            for path in rowsForUpdate {
                if let cell = tableView.cellForRow(at: path) as? CurrencyCell {
                    cell.updateValue()
                }
            }
        }
    }
}

extension CurrencyTableController: CurrencyCellTextDelegate {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CurrencyCell
        let _ = cell.becomeFirstResponder()
    }
    
    func textDidBeginEditing(cell: CurrencyCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let basePath = IndexPath(row: viewModel.baseRow, section: 0)
        viewModel.makeBase(row: indexPath.row)
        
        tableView.moveRow(at: indexPath, to: basePath)
        tableView.scrollToRow(at: basePath, at: .top, animated: true)
    }
    
    func textDidChanged(text: String?) {
        var value: Float?
        if text == nil || text == "" {
            value = nil
        } else if let castedValue = Float(text!) {
            value = castedValue
        }
        
        viewModel.updateBaseValue(value: value)
        updateCells()
    }
}

extension CurrencyTableController {
    
    private func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: timerInterval,
            target: self,
            selector: (#selector(self.updateTimer)),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func stopTimer() {
        timer.invalidate()
    }
    
    @objc private func updateTimer() {
        viewModel.updateConverter {
            DispatchQueue.main.async {
                self.updateCells()
            }
        }
    }
}
