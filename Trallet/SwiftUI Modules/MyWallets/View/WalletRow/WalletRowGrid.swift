//
//  WalletRowGrid.swift
//  Trallet
//
//  Created by Nicholas on 25/08/21.
//

import SwiftUI

struct WalletRowGrid: View {
    @Binding var walletData: Wallet
    @StateObject var viewModel = WalletRowViewModel()
    
    var body: some View {
        VStack {
            ThumbnailSquare(.grid, disp: .constant(viewModel.getWalletThumb(wallet: walletData)), color: .constant(viewModel.getColor(wallet: walletData)))
            VStack(alignment: .leading) {
                Text(viewModel.getWalletName(wallet: walletData))
                    .font(.title)
                Text("Wallet Balance")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Rp 50.000,00")
                    .font(.title3)
            }
        }
        .background(Color("card_background"))
        .cornerRadius(14)
        .background(Color("app_background"))
    }
}

struct WalletRowGrid_Previews: PreviewProvider {
    static var previews: some View {
        WalletRowGrid(walletData: .constant(Wallet(context: TralletStorage.shared.context)))
    }
}
