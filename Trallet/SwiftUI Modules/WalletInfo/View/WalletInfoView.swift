//
//  WalletInfoView.swift
//  Trallet
//
//  Created by Nicholas on 23/08/21.
//

import SwiftUI

struct WalletInfoView: View {
    @ObservedObject var viewModel: WalletInfoViewModel
    
    init(wallet: Wallet) {
        self.viewModel = WalletInfoViewModel(wallet: wallet)
    }
    
    var body: some View {
        List {
            Section("Wallet Status") {
                TabView {
                    InfoView()
                    VStack {
                        HStack {
                            Text("Page 2")
                            Spacer()
                            Text("Desc")
                        }
                        Text("Page yang dibawah ini")
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
        }
        .navigationTitle("\(viewModel.walletToShow.walletName!)")
        .listStyle(GroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("Should show modal")
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
    }
}

struct WalletInfoView_Previews: PreviewProvider {
    static var previews: some View {
        WalletInfoView(wallet: Wallet())
    }
}
