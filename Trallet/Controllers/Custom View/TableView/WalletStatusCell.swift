//
//  WalletStatusCell.swift
//  Trallet
//
//  Created by Nicholas on 30/04/21.
//

import UIKit

enum WalletStatusType: String {
    case cash = "Cash"
    case cc = "Credit Card"
}

class WalletStatusCell: UITableViewCell {
    // Wallet status type
    var enumWalletStat: WalletStatusType! {
        didSet {
            walletType.text = enumWalletStat.rawValue
            switch enumWalletStat {
            case .cash:
                balanceOrExpenseCC.text = "Balance"
                exchangeCCTitleLabel.text = "Amount of cash exchanged"
            case .cc:
                balanceOrExpenseCC.text = "Total Expense"
                exchangeCCTitleLabel.text = "Transaction Limit"
                totalHeight.constant = 0
            default:
                print("Unidentified")
            }
            print(totalStackView.frame.size.height
            )
        }
    }
    
    @IBOutlet weak var walletType: UILabel!
    @IBOutlet weak var cardBackground: UIView!
    
    // Balance or Expense Using CC
    @IBOutlet weak var balanceOrExpenseCC: UILabel!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var baseCurrencyBalanceLabel: UILabel!
    
    // Amount of cash exchanged or CC Limit
    @IBOutlet weak var amountExchangeCCLimitView: UIView!
    @IBOutlet weak var exchangeCCTitleLabel: UILabel!
    @IBOutlet weak var homeCurrencyLabel: UILabel!
    @IBOutlet weak var homeCurrencyBalanceLabel: UILabel!
    @IBOutlet weak var exchangedLimitHeight: NSLayoutConstraint!
    
    // Total Income and Expenses View (Hide this on CC)
    @IBOutlet weak var totalStackView: UIStackView!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var totalHeight: NSLayoutConstraint!
    
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
