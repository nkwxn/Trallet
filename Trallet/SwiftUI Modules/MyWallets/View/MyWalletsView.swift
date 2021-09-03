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
                .navigationTitle("My Trip Wallets")
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
                            viewModel.showNewEditWalletModal.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigation) {
                        EditButton()
                    }
                }
                .popover(isPresented: $viewModel.showNewEditWalletModal) {
                    AddEditWalletView(firstViewModel: self.viewModel)
                }
                .onAppear {
                    // Temporary code. Replace this when SwiftUI 3.0 released
                    UITableView.appearance().backgroundColor = UIColor(named: "app_background")
                    UITableView.appearance().separatorStyle = .none
                    
                    // Load table
                    print("view appear")
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
            }
        }
    }
    
    var emptyState: some View {
        ZStack {
            Color("app_background")
                .ignoresSafeArea()
            VStack(spacing: 8) {
                Spacer()
                Text("Traveling really soon? 🛫")
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("Add your new wallet by clicking the + button on the top right corner")
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
                        destination: WalletInfoView()) {
                        EmptyView()
                            .cornerRadius(14)
                    }
                    WalletRowInline(
                        walletData: $viewModel.wallets[idx]
                    )
                }
                .contextMenu(ContextMenu {
                    Button {
                        print("Should edit \(wallet.walletName!)")
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
                .listStyle(PlainListStyle())
                .listRowBackground(Color("app_background"))
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
                        WalletRowGrid(walletData: $viewModel.wallets[idx])
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
