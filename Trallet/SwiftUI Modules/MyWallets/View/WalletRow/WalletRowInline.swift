//
//  WalletRowView.swift
//  Trallet
//
//  Created by Nicholas on 22/08/21.
//

import SwiftUI

struct WalletRowInline: View {
    @Binding var walletData: Wallet
    @StateObject var viewModel = WalletRowViewModel()
    
    var body: some View {
        HStack {
            ThumbnailSquare(
                .inline,
                disp: .constant(viewModel.getWalletThumb(wallet: walletData)),
                color: .constant(viewModel.getColor(wallet: walletData))
            )
            .frame(width: 75)
            VStack(alignment: .leading) {
                Text(viewModel.getWalletName(wallet: walletData))
                    .font(.title)
                Text("Wallet Balance")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(viewModel.getCurrentBalance(wallet: walletData))
                    .font(.title3)
            }
            Spacer()
        }
        .background(Color("card_background"))
        .cornerRadius(14)
        .background(Color("app_background"))
    }
}

//struct WalletRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletRowInline(walletData: <#Binding<Wallet>#>)
//    }
//}
