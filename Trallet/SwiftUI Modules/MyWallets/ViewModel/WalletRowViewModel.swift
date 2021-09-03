//
//  WalletRowViewModel.swift
//  Trallet
//
//  Created by Nicholas on 25/08/21.
//

import SwiftUI

class WalletRowViewModel: ObservableObject {
    func getWalletName(wallet: Wallet) -> String {
        guard let walletName = wallet
                .walletName
        else {
            return "Unknown"
        }
        return walletName
    }
    
    func getCurrentBalance(wallet: Wallet) -> String {
        guard let code = wallet.walletBaseCurrency
        else {
            return "Unknown balance"
        }
        let balance = wallet.walletBaseBalance
        let format = NumberFormatter()
        format.numberStyle = .currency
        format.locale = Locale.current
        format.currencyCode = code
        guard let final = format
                .string(from: NSNumber(value: balance))
        else {
            return "Unknown balance"
        }
        return final
    }
    
    func getWalletThumb(wallet: Wallet) -> String {
        guard let walletThumb = wallet
                .walletThumb
        else {
            return "␀"
        }
        return walletThumb
    }
    
    func getColor(wallet: Wallet) -> UIColor {
        guard let color = wallet.walletThumbBG as? UIColor else { return UIColor.gray }
        return color
    }
}
