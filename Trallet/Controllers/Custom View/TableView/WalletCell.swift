//
//  WalletCell.swift
//  Trallet
//
//  Created by Nicholas on 30/04/21.
//

import UIKit

class WalletCell: UITableViewCell {
    // Input core data object
    var cdWallet: Wallet! {
        // Set all of the text field and
        didSet {
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.minimumFractionDigits = 2
            nf.maximumFractionDigits = 2
            
            thumbnailBG.backgroundColor = cdWallet.walletThumbBG as? UIColor
            circleThumbnailLabel.text = cdWallet.walletThumb
            walletName.text = cdWallet.walletName
            walletBalance.text = "\(String(describing: cdWallet.walletBaseCurrency!)) \(nf.string(from: NSNumber(value: cdWallet.walletBaseBalance))!)"
        }
    }
    
    // Card
    @IBOutlet weak var cardBackground: UIView!
    
    // Thumb
    @IBOutlet weak var thumbnailBG: CircleThumbnailView!
    @IBOutlet weak var circleThumbnailLabel: UILabel!
    
    // Informations
    @IBOutlet weak var walletName: UILabel!
    @IBOutlet weak var walletBalance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardBackground.layer.cornerRadius = 8.0
        cardBackground.layer.masksToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
