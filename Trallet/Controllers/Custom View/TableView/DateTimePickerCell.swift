//
//  DateTimePickerCell.swift
//  Trallet
//
//  Created by Nicholas on 29/04/21.
//

import UIKit

enum DateTimeCategory: String {
    case dateExchanged = "Cash exchanged on"
    case dateTimeTransaction = "Date & Time"
}

class DateTimePickerCell: UITableViewCell {
    var relatedView: UITableViewController!
    var category: DateTimeCategory! {
        didSet {
            titleLabel.text = category.rawValue
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        datePicker.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - DatePicker Delegate Method

