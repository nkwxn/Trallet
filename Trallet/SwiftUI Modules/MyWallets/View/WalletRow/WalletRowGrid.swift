//
//  WalletRowGrid.swift
//  Trallet
//
//  Created by Nicholas on 25/08/21.
//

import SwiftUI

struct WalletRowGrid: View {
    var walletData: Wallet
    @StateObject var viewModel = WalletRowViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
            .padding(10)
        }
        .background(Color("card_background"))
        .cornerRadius(14)
    }
}

struct WalletRowGrid_Previews: PreviewProvider {
    static var previews: some View {
        WalletRowGrid(walletData: Wallet(context: TralletStorage.shared.context))
            .previewLayout(.sizeThatFits)
            .frame(width: 200, height: 300)
    }
}
