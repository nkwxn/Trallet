//
//  WalletInfoViewModel.swift
//  Trallet
//
//  Created by Nicholas on 10/09/21.
//

import Combine

class WalletInfoViewModel: ObservableObject {
    // Helpers
    var cdHelper = TralletStorage.shared
    var udHelper = UserDefaultsModel.shared
    
    // Data
    @Published var walletToShow: Wallet
    @Published var filteredTransaction: [Transaction] = []
    
    private var cancellable: AnyCancellable?
    
    init(
        wallet filterWallet: Wallet,
        transactionPublisher: AnyPublisher
        <[Transaction], Never> = TralletStorage
        .shared.transactions.eraseToAnyPublisher()
    ) {
        self.walletToShow = filterWallet
        cancellable = transactionPublisher
            .sink { trans in
                self.filteredTransaction = trans.filter { filterTrans in
                    filterTrans.parentWallet == filterWallet
                }
            }
    }
}
