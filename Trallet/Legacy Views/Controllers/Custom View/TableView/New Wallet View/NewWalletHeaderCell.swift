//
//  NewWalletHeaderCell.swift
//  Trallet
//
//  Created by Nicholas on 29/04/21.
//

import UIKit

class NewWalletHeaderCell: UITableViewCell {
    var newWalletView: NewWalletController!
    
    @IBOutlet weak var lblThumbnail: UILabel!
    @IBOutlet weak var bgThumbnail: CircleThumbnailView!
    @IBOutlet weak var tfWalletName: UITextField!
    
    var headerDelegate: NewWalletHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        bgThumbnail.addGestureRecognizer(tap)
        tfWalletName.delegate = self
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        newWalletView.performSegue(withIdentifier: "changeImage", sender: newWalletView.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension NewWalletHeaderCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        headerDelegate?.passWalletName(walletName: "\(textField.text!)\(string)")
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("Ended editing. Text captured: \(textField.text!)")
        headerDelegate?.passWalletName(walletName: "\(textField.text!)")
    }
}

protocol NewWalletHeaderDelegate {
    func passWalletName(walletName name: String?)
}
