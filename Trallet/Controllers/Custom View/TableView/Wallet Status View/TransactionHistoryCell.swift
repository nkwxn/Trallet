//
//  TransactionHistoryCell.swift
//  Trallet
//
//  Created by Nicholas on 02/05/21.
//

import UIKit

//MARK: Protocol to get reuse ID
public protocol Reusable {
    static func ReuseID() -> String
}

// MARK: - Protocol to make header / footer rounded corner
protocol MaskedCorner {
    func maskTopOnlyRoundedCorner(for view: UIView)
    func maskBottomOnlyRoundedCorner(for view: UIView)
}

// MARK: - Implementation for MaskedCorner
extension MaskedCorner {
    func maskTopOnlyRoundedCorner(for view: UIView) {
        view.layer.cornerRadius = CGFloat(8.0)
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func maskBottomOnlyRoundedCorner(for view: UIView) {
        view.layer.cornerRadius = CGFloat(8.0)
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func maskAllRoundedCorner(for view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

// MARK: - History Header
class TransactionHistoryHeader: UITableViewHeaderFooterView, MaskedCorner {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    var formatter = DateFormatter()
    
    var transactionDate: Date! {
        didSet {
            formatter.dateStyle = .full
            formatter.timeStyle = .none
            lblDate.text = formatter.string(from: transactionDate)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.maskTopOnlyRoundedCorner(for: borderView)
    }
}

extension TransactionHistoryHeader: Reusable {
    static func ReuseID() -> String {
        return String(describing: self)
    }
}

// MARK: - History Cell

class TransactionHistoryCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    /*
     Notes:
     sf symbol for payment method:
     Cash: dollarsign.circle.fill color: orange to yellow
     credit card: creditcard.fill color: purple-pink
     
     sf symbol for income expense:
     income: plus.circle.fill color: green
     expense: minus.circle.fill color: red
    */
    
    // First section
    @IBOutlet weak var transactionTimeLabel: UILabel!
    @IBOutlet weak var transactionPaymentType: UILabel!
    @IBOutlet weak var paymentTypeThumb: UIImageView!
    
    @IBOutlet weak var paymentTypeLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var paymentTypeThumbWidth: NSLayoutConstraint!
    
    // Money spent and Income / Expense indicator
    @IBOutlet weak var amountSpentLabel: UILabel!
    @IBOutlet weak var transactionTypeImg: UIImageView!
    
    // Category, notes and location keyword
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var locationThumb: UIImageView!
    @IBOutlet weak var locationKeywordLabel: UILabel!
    @IBOutlet weak var notesHeight: NSLayoutConstraint!
    @IBOutlet weak var keywordLblHeight: NSLayoutConstraint!
    @IBOutlet weak var locIconHeight: NSLayoutConstraint!
    
    // CD Object
    var cdTransaction: Transaction! {
        // Tuliskan disini kalo ada yg ingin diituin
        didSet {
            let timeFormat = DateFormatter()
            timeFormat.timeStyle = .short
            timeFormat.dateStyle = .none
            guard let tDateTime = cdTransaction.transDateTime else { return }
            transactionTimeLabel.text = timeFormat.string(from: tDateTime)
            
            // Declare safe variables (optional -> non-optionals)
            guard let type = cdTransaction.transType else { return }
            guard let category = cdTransaction.transCategory else { return }
            guard let baseCurrency = cdTransaction.parentWallet?.walletBaseCurrency else { return }
            
            // Declare Number Formatter for Transactioning
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.minimumFractionDigits = 2
            nf.maximumFractionDigits = 2
            
            // Payment type and the label
            if let paymentMethod = cdTransaction.transPaymentMethod {
                transactionPaymentType.text = paymentMethod
                paymentTypeThumb.image = paymentMethod == "Cash" ? UIImage(systemName: "dollarsign.circle.fill") : UIImage(systemName: "creditcard.circle.fill")
                paymentTypeThumb.tintColor = UIColor(named: "AccentColor")
            } else {
                paymentTypeLabelWidth.constant = 0
                paymentTypeThumbWidth.constant = 0
            }
            
            // Set category label
            categoryLabel.text = category
            
            amountSpentLabel.text = "\(baseCurrency) \(nf.string(from: NSNumber(value: cdTransaction.transAmount))!)"
            
            // Set the amount of transaction and transaction type image
            if type == "Income" {
                transactionTypeImg.image = UIImage(systemName: "plus.circle.fill")
                transactionTypeImg.tintColor = UIColor.systemGreen
            } else {
                transactionTypeImg.image = UIImage(systemName: "minus.circle.fill")
                transactionTypeImg.tintColor = UIColor.systemRed
            }
            
            // Set notes label
            if let notes = cdTransaction.transNotes {
                notesLabel.text = notes
            } else {
                notesLabel.text = ""
                notesHeight.constant = 0
            }
            
            // Set location keyword
            if let locationKeyword = cdTransaction.transLocationKeyword {
                locationKeywordLabel.text = locationKeyword
            } else {
                locationKeywordLabel.text = ""
                keywordLblHeight.constant = 0
                locIconHeight.constant = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("Selected transaction: \(cdTransaction!)")
        
    }
}

extension TransactionHistoryCell: Reusable {
    static func ReuseID() -> String {
        return String(describing: self)
    }
}

// MARK: - History Footer
class TransactionHistoryFooter: UITableViewHeaderFooterView, MaskedCorner {
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.maskBottomOnlyRoundedCorner(for: view)
    }
}

extension TransactionHistoryFooter: Reusable {
    static func ReuseID() -> String {
        return String(describing: self)
    }
}
