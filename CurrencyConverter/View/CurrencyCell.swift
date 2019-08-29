//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by Jag Stang on 22/01/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

protocol CurrencyCellTextDelegate {
    func textDidBeginEditing(cell: CurrencyCell)
    func textDidChanged(text: String?)
}

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyField: UITextField!
    
    var viewModel: CurrencyCellViewModel?
    var delegate: CurrencyCellTextDelegate?
    
    public func configure(with viewModel: CurrencyCellViewModel) {
        self.viewModel = viewModel
        currencyLabel?.text = viewModel.name
        currencyField?.text = viewModel.value
        currencyField?.addTarget(self, action: #selector(self.textDidChanged(textField:)), for: .editingChanged)
        currencyField?.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.viewModel = nil
        currencyLabel?.text = ""
        currencyField?.text = ""
        currencyField?.removeTarget(nil, action: nil, for: .allEvents)
        currencyField?.delegate = nil
    }
    
    override func becomeFirstResponder() -> Bool {
        return currencyField?.becomeFirstResponder() ?? true
    }
    
    public func updateValue() {
        currencyField?.text = viewModel?.value ?? ""
    }
}

extension CurrencyCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textDidBeginEditing(cell: self)
    }
    
    @objc func textDidChanged(textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        viewModel?.updateCurrencyValue(value: Float(text))
        delegate?.textDidChanged(text: text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let range = Range(range, in: text) {
            let textResult = text.replacingCharacters(in: range, with: string)
            return viewModel?.validateInputValue(textResult) ?? false
        }
        
        return true
    }
}
