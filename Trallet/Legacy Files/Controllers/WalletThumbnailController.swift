//
//  WalletThumbnailController.swift
//  Trallet
//
//  Created by Nicholas on 29/04/21.
//

import UIKit

class WalletThumbnailController: UIViewController {
    // Previous page
    var newWalletView: NewWalletController!
    var thumb: String!
    var bgColor: UIColor!
    
    // Bar Button Item
    @IBOutlet weak var barBtnDone: UIBarButtonItem!
    
    @IBOutlet weak var circleThumb: CircleThumbnailView!
    @IBOutlet weak var scInputType: UISegmentedControl!
    @IBOutlet weak var backgroundChoiceStack: UIStackView!
    @IBOutlet weak var tfIcon: UITextField!
    
    // BG Color for setting text
    @IBOutlet weak var btnGray: CircularButton!
    @IBOutlet weak var btnPink: CircularButton!
    @IBOutlet weak var btnRed: CircularButton!
    @IBOutlet weak var btnOrange: CircularButton!
    @IBOutlet weak var btnYellow: CircularButton!
    @IBOutlet weak var btnBlue: CircularButton!
    @IBOutlet weak var btnPurple: CircularButton!
    @IBOutlet weak var btnGreen: CircularButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        circleThumb.backgroundColor = bgColor
        tfIcon.text = thumb
        enableTextEmoji(true)
        tfIcon.becomeFirstResponder()
        tfIcon.delegate = self
    }
    
    @IBAction func backgroundChosen(_ sender: UIButton) {
        circleThumb.backgroundColor = sender.backgroundColor
    }
    
    func enableTextEmoji(_ isEnabled: Bool) {
        backgroundChoiceStack.isHidden = isEnabled
        tfIcon.isEnabled = isEnabled
        
        let arrButtons = [btnGray, btnRed, btnPink, btnOrange, btnYellow, btnGreen, btnBlue, btnPurple]
        for btn in arrButtons {
            btn?.setTitle(tfIcon.text, for: .normal)
        }
    }
    
    @IBAction func settingChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            enableTextEmoji(true)
            tfIcon.becomeFirstResponder()
        case 1:
            enableTextEmoji(false)
        default:
            print("Segment not identified")
        }
    }
    
    @IBAction func onClickBarBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            if sender.isEqual(self.barBtnDone) {
                // Background dan thumbnail akan dikembalikan ke halaman sebelumnya
                self.newWalletView.changeThumb(thumb: self.tfIcon.text!, bg: self.circleThumb.backgroundColor!)
                self.newWalletView.thumbBG = self.circleThumb.backgroundColor!
                self.newWalletView.thumbTxt = self.tfIcon.text!
            }
        }
    }
}

extension WalletThumbnailController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if text.containsEmoji {
                var textV = text
                textV.removeLast()
                textField.text = textV
            }
        }
        
        let limit: Int = textField.text?.isSingleEmoji ?? false ? 1 : 2
        return self.textLimit(existingText: textField.text, newText: string, limit: limit)
    }
    
    private func textLimit(existingText: String?, newText: String, limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
}
