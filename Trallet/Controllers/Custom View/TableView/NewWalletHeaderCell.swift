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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        bgThumbnail.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        newWalletView.performSegue(withIdentifier: "changeImage", sender: newWalletView.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
