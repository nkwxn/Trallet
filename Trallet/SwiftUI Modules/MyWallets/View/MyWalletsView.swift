//
//  MyWalletsView.swift
//  Trallet
//
//  Created by Nicholas on 21/08/21.
//

import SwiftUI

struct MyWalletsView: View {
    @StateObject var viewModel = WalletsViewModel()
    
    // MARK: - Main Skeleton / View
    var body: some View {
        NavigationView {
            listView
                .navigationTitle("my_wallets")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.viewAsGrid.toggle()
                        } label: {
                            Image(systemName: "square.grid.2x2")
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            viewModel.showAddEditWallet()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigation) {
                        EditButton()
                    }
                }
                .sheet(
                    isPresented: $viewModel
                        .showNewEditWalletModal
                ) {
                    AddEditWalletView(wallet: viewModel.walletToUpdate)
                }
                .onDisappear {
                    print("view disappear")
                }
        }
    }
    
    @ViewBuilder
    var listView: some View {
        if viewModel.wallets.isEmpty {
            emptyState
        } else {
            if viewModel.viewAsGrid {
                walletGrid
            } else {
                walletList
                    .listStyle(PlainListStyle())
            }
        }
    }
    
    var emptyState: some View {
        ZStack {
            Color("app_background")
                .ignoresSafeArea()
            VStack(spacing: 8) {
                Spacer()
                Text("traveling_really_soon")
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("add_wallet_plus")
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding()
        }
    }
    
    var walletList: some View {
        List {
            ForEach(
                Array(
                    viewModel.wallets.enumerated()
                ),
                id: \.0
            ) { (idx, wallet) in
                ZStack {
                    NavigationLink(
                        destination: WalletInfoView(wallet: wallet)) {
                        EmptyView()
                            .cornerRadius(14)
                    }
                    .opacity(0)
                    WalletRowInline(
                        walletData: viewModel.wallets[idx]
                    )
                }
                .contextMenu(ContextMenu {
                    Button {
                        viewModel.showAddEditWallet(for: wallet)
                    } label: {
                        Image(systemName: "square.and.pencil")
                        Text("Edit")
                    }
                    Button {
                        // TODO: Replace this with show alert
                        viewModel.cdHelper.deleteWallet(for: wallet)
                    } label: {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                })
                .listRowSeparator(.hidden)
                .listRowBackground(Color("app_background"))
                .background(Color("app_background").ignoresSafeArea())
            }
            // Replace this when SwiftUI 3.0 is released
            .onDelete(
                perform: viewModel
                    .deleteWallet
            )
        }
    }
    
    var walletGrid: some View {
        ZStack {
            Color("app_background")
                .ignoresSafeArea()
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(), GridItem()]
                ) {
                    ForEach(
                        Array(
                            viewModel.wallets.enumerated()
                        ),
                        id: \.0) { (idx, wallet) in
                        WalletRowGrid(walletData: viewModel.wallets[idx])
                    }
                }
                .padding()
            }
        }
    }
}

struct MyWalletsView_Previews: PreviewProvider {
    static var previews: some View {
        MyWalletsView()
    }
}
