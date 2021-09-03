//
//  File.swift
//  Trallet
//
//  Created by Nicholas on 05/05/21.
//

import Foundation
import UIKit

class OrangeBorderTextField: UITextField {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Create an orange rounded corner
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        self.layer.cornerRadius = 8
    }
    
    func orangeBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        self.layer.cornerRadius = 8
    }
}
