//
//  NewEditWalletViewModel.swift
//  Trallet
//
//  Created by Nicholas on 23/08/21.
//

import SwiftUI
import Combine

class AddEditWalletViewModel: ObservableObject {
    // Helpers userdefaults buat nge load,
    let udHelper = UserDefaultsModel.shared
    let cdHelper = TralletStorage.shared
    private var cancellable: AnyCancellable?
    
    // Basic Info
    @Published var walletName: String = ""
    @Published var thumbnailString: String = ""
    @Published var homeCurrency: String = "" {
        didSet {
            // Ini mungkin lebih tepat di set saat di input type picker deh
            udHelper.setHomeCurrency(code: homeCurrency)
        }
    }
    @Published var exchangeCurrency: String = ""
    
    // Numbers
    @Published var cashAmount: Double = 0
    @Published var cashExchange: Double = 0
    @Published var ccLimit: Double = 0
    
    // TODO: GANTI INI ke color gray yg di trallet apps (kalo ga ada yg mau di init)
    @Published var thumbnailColor: UIColor = UIColor(named: "thumb_gray")!
    
    @Published var isGoingOverseas: Bool = false
    @Published var isUsingCreditCard: Bool = false
    @Published var isEditingThumb: Bool = false
    
    // Wallet (for update)
    var walletToUpdate: Wallet?
    
    init(wallet forUpdate: Wallet?) {
        self.homeCurrency = udHelper.getHomeCurrency()
        
        // Set the labels, text and currencies while wallet for update not nil
        self.walletToUpdate = forUpdate
        if let walletToUpdate = walletToUpdate {
            self.thumbnailColor = walletToUpdate.walletThumbBG as! UIColor
            self.thumbnailString = walletToUpdate.walletThumb ?? ""
            self.walletName = walletToUpdate.walletName ?? ""
            
            if walletToUpdate.walletCreditCardLimit != 0 {
                self.isUsingCreditCard = true
                self.ccLimit = walletToUpdate.walletCreditCardLimit
            } else {
                self.isUsingCreditCard = false
                self.ccLimit = 0
            }
            
            if walletToUpdate.walletOriginConvertionCash != 0 {
                self.isGoingOverseas = true
                self.homeCurrency = walletToUpdate.walletOriginCurrency ?? ""
                self.cashAmount = walletToUpdate.walletOriginConvertionCash
                self.exchangeCurrency = walletToUpdate.walletBaseCurrency ?? ""
                self.cashExchange = walletToUpdate.walletBaseBalance
            } else {
                self.isGoingOverseas = false
                self.homeCurrency = walletToUpdate.walletBaseCurrency ?? ""
                self.cashAmount = walletToUpdate.walletBaseBalance
            }
        }
    }
    
    // Change thumb when done button pressed on change thumb view
    func changeThumbnail(thumb: String, color: UIColor) {
        
    }
    
    // Input the wallet into persistent storage. Input the validation as well
    func onDoneButtonPressed() {
        if walletToUpdate != nil {
            // update
        } else {
            // create new
            if isGoingOverseas && isUsingCreditCard {
                cdHelper.createNewWallet(
                    thumbBackground: self.thumbnailColor,
                    thumbText: self.thumbnailString,
                    name: self.walletName,
                    baseCurrency: self.exchangeCurrency,
                    baseCash: self.cashExchange,
                    originCurrency: self.homeCurrency,
                    originCash: self.cashAmount,
                    ccCurrency: self.homeCurrency,
                    ccLimit: self.ccLimit
                )
            } else if isGoingOverseas && !isUsingCreditCard {
                cdHelper.createNewWallet(
                    thumbBackground: self.thumbnailColor,
                    thumbText: self.thumbnailString,
                    name: self.walletName,
                    baseCurrency: self.exchangeCurrency,
                    baseCash: self.cashExchange,
                    originCurrency: self.homeCurrency,
                    originCash: self.cashAmount
                )
            } else if !isGoingOverseas && isUsingCreditCard {
                cdHelper.createNewWallet(
                    thumbBackground: self.thumbnailColor,
                    thumbText: self.thumbnailString,
                    name: self.walletName,
                    baseCurrency: self.homeCurrency,
                    baseCash: self.cashAmount,
                    ccCurrency: self.homeCurrency,
                    ccLimit: self.ccLimit
                )
            } else {
                cdHelper.createNewWallet(
                    thumbBackground: self.thumbnailColor,
                    thumbText: self.thumbnailString,
                    name: self.walletName,
                    baseCurrency: self.homeCurrency,
                    baseCash: self.cashAmount
                )
            }
        }
//        viewModel.cdHelper
//            .createNewWallet(
//                thumbBackground: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),
//                thumbText: "🇮🇩",
//                name: "Test",
//                baseCurrency: "IDR",
//                baseCash: 50000000
//            )
    }
}
