//
//  WalletRowTableViewCell.swift
//  Trallet
//
//  Created by Nicholas on 01/01/22.
//

import UIKit

class WalletRowTableViewCell: UITableViewCell {
    weak var walletData: Wallet! {
        didSet {
            // Set everything here!
        }
    }
    
    @IBOutlet weak var circleBgView: CircleThumbnailView!
    @IBOutlet weak var thumbTxtLbl: UILabel!
    
    @IBOutlet weak var walletNameLbl: UILabel!
    @IBOutlet weak var currentBalanceLbl: UILabel!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
}
