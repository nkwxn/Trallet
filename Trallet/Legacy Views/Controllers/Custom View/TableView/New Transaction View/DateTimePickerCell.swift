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

    var pickerDelegate: DateTimeCategoryDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        datePicker.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        pickerDelegate?.fetchDateTime(datePicker.date)
        datePicker.semanticContentAttribute = .forceRightToLeft
        datePicker.subviews.first?.semanticContentAttribute = .forceRightToLeft
    }
    
    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        print(sender.date)
        pickerDelegate?.fetchDateTime(sender.date)
    }

}

// MARK: - DatePicker Delegate Method
protocol DateTimeCategoryDelegate {
    func fetchDateTime(_ dateTime: Date)
}
