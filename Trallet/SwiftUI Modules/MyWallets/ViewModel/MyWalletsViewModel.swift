//
//  MyWalletsViewModel.swift
//  Trallet
//
//  Created by Nicholas on 22/08/21.
//

import Foundation
import SwiftUI
import Combine

class WalletsViewModel: ObservableObject {
    @Published var showNewEditWalletModal = false
    @Published var viewAsGrid = false
    let cdHelper = TralletStorage.shared
    
    // Array of wallets shown
    @Published var wallets: [Wallet] = [] {
        willSet {
            print("Updating wallets to: \(newValue)")
        }
    }
    
    private var cancellable: AnyCancellable?
    
    init(
        walletPublisher: AnyPublisher
        <[Wallet], Never> = TralletStorage
        .shared.wallets.eraseToAnyPublisher()
    ) {
        cancellable = walletPublisher.sink { wallets in
            self.wallets = wallets
        }
    }
    
    func deleteWallet(on offset: IndexSet) {
        let walletToDelete = offset.map { wIndex in
            self.wallets[wIndex]
        }[0]
        
        wallets.remove(atOffsets: offset)
        
        // Run function on TralletStorage
        cdHelper.deleteWallet(for: walletToDelete)
    }
}
