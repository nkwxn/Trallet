//
//  AmountMoneyCell.swift
//  Trallet
//
//  Created by Nicholas on 30/04/21.
//

import UIKit

class AmountMoneyCell: UITableViewCell {
    let defaults = UserDefaults.standard
    
    var enumWallet: WalletStatusType! {
        didSet {
            switch enumWallet {
            case .cash:
                title.text = "Amount of Cash"
            case .cc:
                title.text = "Credit Card Limit"
            default:
                print("Unidentified")
            }
        }
    }
    
    var amountDelegate: AmountMoneyDelegate?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfCurrency: UITextField!
    
    var currencyPicker = CurrencyPicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        currencyPicker.delegate = currencyPicker as UIPickerViewDelegate
        currencyPicker.dataSource = currencyPicker as UIPickerViewDataSource
        currencyPicker.currencyDelegate = self
        
        tfCurrency.inputView = currencyPicker
        tfCurrency.delegate = self
        tfAmount.delegate = self
        
        tfCurrency.text = defaults.string(forKey: "homeCurrency")
    }

}

protocol AmountMoneyDelegate {
    func sendData(_ walletStatus: WalletStatusType, currencyCode: String?, amount: Double?)
}

// MARK: - Currency Picker Delegate to set text on a field used
extension AmountMoneyCell: CurrencyPickerDelegate, UITextFieldDelegate {
    func pickerDidSelectRow(selected currencyCode: String) {
        tfCurrency.text = currencyCode
        defaults.set(currencyCode, forKey: "homeCurrency")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        amountDelegate?.sendData(enumWallet, currencyCode: tfCurrency.text!, amount: Double("\(tfAmount.text!)\(string)"))
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("\(enumWallet.rawValue): \(tfCurrency.text!) \(tfAmount.text!)")
        amountDelegate?.sendData(enumWallet, currencyCode: tfCurrency.text!, amount: Double("\(tfAmount.text!)"))
    }
}
