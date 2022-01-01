//
//  TransactionAmountSpentCell.swift
//  Trallet
//
//  Created by Nicholas on 03/05/21.
//

import UIKit

class TransactionAmountSpentCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var txtFieldAmount: UITextField!
    
    var cdWallet: Wallet! {
        didSet {
            lblCurrency.text = cdWallet.walletBaseCurrency ?? "---"
        }
    }
    
    var delegate: TransactionAmountDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtFieldAmount.delegate = self
        txtFieldAmount.addTarget(self, action: #selector(TransactionAmountSpentCell.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard var text = textField.text else { return }
        if text.contains(",") {
            text.removeLast()
            textField.text = "\(text)."
        }
        delegate?.transactionAmount(number: Double(textField.text ?? ""))
    }
}

extension TransactionAmountSpentCell: UITextFieldDelegate {
    // To change the comma into dot
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if string == "," {
            textField.text = "\(text)."
        }
        return true
    }
 */
}

// MARK: - Amount Spent Delegate
protocol TransactionAmountDelegate {
    func transactionAmount(number: Double?)
}
