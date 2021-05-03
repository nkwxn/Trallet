//
//  AttachmentCell.swift
//  Trallet
//
//  Created by Nicholas on 03/05/21.
//

import UIKit

class AttachmentCell: UITableViewCell {
    @IBOutlet weak var btnAddImages: UIButton!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
