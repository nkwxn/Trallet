//
//  TransactionNotesCell.swift
//  Trallet
//
//  Created by Nicholas on 03/05/21.
//

import UIKit

class TransactionNotesCell: UITableViewCell {
    @IBOutlet weak var txtNotes: UITextField!
    var delegate: TransactionNotesDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        txtNotes.addTarget(self, action: #selector(TransactionNotesCell.getText(_:)), for: .editingChanged)
    }

    @objc func getText(_ textField: UITextField) {
        print(textField.text ?? "")
        delegate?.transactionNote(textField.text)
    }
}

protocol TransactionNotesDelegate {
    func transactionNote(_ note: String?)
}
