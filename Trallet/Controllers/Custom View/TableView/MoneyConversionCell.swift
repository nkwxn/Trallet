//
//  MoneyConversionCell.swift
//  Trallet
//
//  Created by Nicholas on 30/04/21.
//

import UIKit

class MoneyConversionCell: UITableViewCell {
    // TODO: Input Core Data Stack and Load User Default on first field
    var defaults = UserDefaults.standard
    var conversionDelegate: MoneyConversionDelegate?
    
    @IBOutlet weak var originCurencyTF: UITextField!
    @IBOutlet weak var targetCurrencyTF: UITextField!
    @IBOutlet weak var originAmountTF: UITextField!
    @IBOutlet weak var targetAmountTF: UITextField!
    
    @IBOutlet weak var originCurrencyLabel: UILabel!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    @IBOutlet weak var originRateTF: UITextField!
    @IBOutlet weak var targetRateTF: UITextField!
    
    var currencyPicker = CurrencyPicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        currencyPicker.delegate = currencyPicker
        currencyPicker.dataSource = currencyPicker
        currencyPicker.currencyDelegate = self
        
        originCurencyTF.inputView = currencyPicker
        targetCurrencyTF.inputView = currencyPicker
        
        originRateTF.delegate = self
        targetRateTF.delegate = self
//        originCurencyTF.delegate = self
        originAmountTF.delegate = self
//        targetCurrencyTF.delegate = self
        targetAmountTF.delegate = self
        
        originCurencyTF.text = defaults.string(forKey: "homeCurrency")
        
        originCurrencyLabel.text = defaults.string(forKey: "homeCurrency")
    }

}

protocol MoneyConversionDelegate {
    func moneyConversionStack(baseCurrency: String?, baseAmount: Double?, originCurrency: String?, originAmount: Double?)
}

extension MoneyConversionCell: CurrencyPickerDelegate, UITextFieldDelegate {
    func pickerDidSelectRow(selected currencyCode: String) {
        // Pass the data
        if self.originCurencyTF.isEditing {
            print("Origin: \(currencyCode)")
            originCurencyTF.text = currencyCode
            originCurrencyLabel.text = currencyCode.count == 0 ? "---" : currencyCode
            defaults.set(currencyCode, forKey: "homeCurrency")
        } else if self.targetCurrencyTF.isEditing {
            print("Target: \(currencyCode)")
            targetCurrencyTF.text = currencyCode
            targetCurrencyLabel.text = currencyCode.count == 0 ? "---" : currencyCode
        }
        
        // Consume API to generate exchange rate if it's available
        // url text: https://www.exchangerate-api.com/ (Ini API gratisan)
        
        if self.originCurencyTF.text != "" && self.targetCurrencyTF.text != "" {
            // Call the API and show exchange rate on the field
            let originCurrency = self.originCurencyTF.text!
            let targetCurrency = self.targetCurrencyTF.text!
            
            let urlString = "https://v6.exchangerate-api.com/v6/47d21e5a5ed4af0a66a2c26d/pair/\(originCurrency)/\(targetCurrency)"
            guard let url = URL(string: urlString) else { return }
            
            // MARK: - Call the API
            // TODO: Create a loading popup while waiting for response
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching rates: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                            (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                        return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let exchangeRate = try decoder.decode(ExchangeRate.self, from: data)
                        print(exchangeRate.conversion_rate)
                        let eRate = exchangeRate.conversion_rate
                        DispatchQueue.main.async {
                            if eRate < 1.0 {
                                // Set text field
                                self.originRateTF.text = String(format: "%.2f", Double(1 / eRate))
                                self.targetRateTF.text = String(format: "%.2f", Double(1))
                            } else {
                                // Set text field
                                self.originRateTF.text = String(format: "%.2f", Double(1))
                                self.targetRateTF.text = String(format: "%.2f", eRate)
                            }
                            
                            guard let originRate = Double(self.originRateTF.text ?? "") else { return }
                            guard let targetRate = Double(self.targetRateTF.text ?? "") else { return }
                            
                            // Detect if amount of cash has been detected
                            if let originAmount = Double(self.originAmountTF.text ?? "") {
                                let targetAmount = originAmount * (targetRate / originRate)
                                self.targetAmountTF.text = String(format: "%.2f", targetAmount)
                            } else if let targetAmount = Double(self.targetAmountTF.text ?? "") {
                                let originAmount = targetAmount * (originRate / targetRate)
                                self.originAmountTF.text = String(format: "%.2f", originAmount)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            
            task.resume()
        } else {
            // Empty the text field
            originRateTF.text = ""
            targetRateTF.text = ""
        }
    }
    
    // MARK: - Text Field Delegate
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let originRate = Double(originRateTF.text ?? "") else { return }
        guard let targetRate = Double(targetRateTF.text ?? "") else { return }
        if textField == originAmountTF {
            if let originAmount = Double(self.originAmountTF.text ?? "") {
                let targetAmount = originAmount * (targetRate / originRate)
                self.targetAmountTF.text = String(format: "%.2f", targetAmount)
            }
        } else if textField == targetAmountTF {
            if let targetAmount = Double(self.targetAmountTF.text ?? "") {
                let originAmount = targetAmount * (originRate / targetRate)
                self.originAmountTF.text = String(format: "%.2f", originAmount)
            }
        } else { // Ini kalo rate origin atau target on
            if let originAmount = Double(self.originAmountTF.text ?? "") {
                let targetAmount = originAmount * (targetRate / originRate)
                self.targetAmountTF.text = String(format: "%.2f", targetAmount)
                print("\(originAmount) : \(targetAmount)")
            } else if let targetAmount = Double(self.targetAmountTF.text ?? "") {
                print("This should be executed")
                let originAmount = targetAmount * (originRate / targetRate)
                self.originAmountTF.text = String(format: "%.2f", originAmount)
                print("\(originAmount) : \(targetAmount)")
            }
        }
        
        conversionDelegate?.moneyConversionStack(baseCurrency: targetCurrencyTF.text, baseAmount: Double(targetAmountTF.text ?? ""), originCurrency: originCurencyTF.text, originAmount: Double(originAmountTF.text ?? ""))
    }
}
