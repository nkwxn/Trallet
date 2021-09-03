//
//  NewEditWalletViewModel.swift
//  Trallet
//
//  Created by Nicholas on 23/08/21.
//

import SwiftUI

class AddEditWalletViewModel: ObservableObject {
    // Basic Info
    @Published var walletName: String = ""
    @Published var thumbnailString: String = ""
    @Published var homeCurrency: String = "" // load this from userdefaults persistence
    @Published var exchangeCurrency: String = ""
    
    // Numbers
    @Published var cashAmount: Double = 0
    @Published var cashExchange: Double = 0
    @Published var ccLimit: Double = 0
    
    // TODO: GANTI INI ke color gray yg di trallet apps
    @Published var thumbnailColor: UIColor = UIColor.gray
    
    @Published var isGoingOverseas: Bool = false
    @Published var isUsingCreditCard: Bool = false
    
    // Input the wallet into persistent storage. Input the validation as well
    func createNewWallet() {
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
