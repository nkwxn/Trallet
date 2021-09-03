//
//  SwitchCell.swift
//  Trallet
//
//  Created by Nicholas on 29/04/21.
//

import UIKit

enum SwitchOption {
    case goingOverseas
    case planUseCC
}

class SwitchCell: UITableViewCell {
    var newWalletView: NewWalletController!
    var switchEnum: SwitchOption! {
        didSet {
            switch switchEnum {
            case .goingOverseas:
                lblTitle.text = "Going Overseas?"
            case .planUseCC:
                lblTitle.text = "Planning to use Credit Card?"
            default:
                lblTitle.text = "Unidentifiable"
            }
        }
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchConfig: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        // Identify which enum and change bool value
        switch switchEnum {
        case .goingOverseas:
            newWalletView.goingOverseas = sender.isOn
        case .planUseCC:
            newWalletView.planningUseCC = sender.isOn
        case .none:
            print("None of the enums are here")
        }
        
        // Reload the TableView
        newWalletView.tableView.beginUpdates()
        newWalletView.tableView.endUpdates()
    }
}
