//
//  TralletStorage.swift
//  Trallet
//
//  Created by Nicholas on 03/09/21.
//

import SwiftUI
import CoreData
import Combine
import MapKit

class TralletStorage: NSObject, ObservableObject {
    // Wallet Instance
    var wallets = CurrentValueSubject<[Wallet], Never>([])
    private var walletFetchController: NSFetchedResultsController<Wallet>
    
    // Transaction Instance
    var transactions = CurrentValueSubject<[Transaction], Never>([])
    
    // @FetchRequest(entity: Wallet.entity(), sortDescriptors: [])
    private var transactionFetchController: NSFetchedResultsController<Transaction>
    
    // Singleton Instance
    static let shared: TralletStorage = TralletStorage()
    
    // Context
    var context = (
        UIApplication
            .shared
            .delegate
            as! AppDelegate
    ).persistentContainer.viewContext
    
    // initializer
    override init() {
        let walletSort = NSSortDescriptor(key: "walletCreationDate", ascending: false)
        let transSort = NSSortDescriptor(key: "transDateTime", ascending: false)
        let walletFetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        let transactionFetchRequest: NSFetchRequest<Transaction> = Transaction
            .fetchRequest()
        walletFetchRequest.sortDescriptors = [walletSort]
        transactionFetchRequest.sortDescriptors = [transSort]
        
        walletFetchController = NSFetchedResultsController(
            fetchRequest: walletFetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        transactionFetchController = NSFetchedResultsController(
            fetchRequest: transactionFetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        // Initialize delegate
        walletFetchController
            .delegate = self
        transactionFetchController
            .delegate = self
        
        do {
            try walletFetchController
                .performFetch()
            try transactionFetchController
                .performFetch()
            
            wallets.value = walletFetchController.fetchedObjects ?? []
            transactions.value = transactionFetchController.fetchedObjects ?? []
        } catch {
            NSLog("Error: could not fetch objects")
        }
    }
    
    // Save datas after CRUD Methods
    func save() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
}

// MARK: - CRUD Methods for Wallets
extension TralletStorage {
    // Base: Mata uang yang akan digunakan dalam pencatatan transaksi
    // Origin: Mata uang yang akan digunakan sebagai dasar conversion rate
    
    // MARK: - CREATE new Wallet
    func createNewWallet(thumbBackground: UIColor, thumbText: String, name: String, baseCurrency: String, baseCash: Double, originCurrency: String? = nil, originCash: Double? = nil, moneyChangedDate: Date? = nil, ccCurrency: String? = nil, ccLimit: Double? = nil) {
        let creationDate = Date()
        
        // Initializing new wallet
        let newWallet = Wallet(context: context)
        newWallet.walletThumbBG = thumbBackground
        newWallet.walletThumb = thumbText
        newWallet.walletName = name
        newWallet.walletCreationDate = creationDate
        newWallet.walletBaseCurrency = baseCurrency
        newWallet.walletBaseBalance = baseCash
        
        if let originCash = originCash,
           let originCurrency = originCurrency {
            newWallet.walletOriginCurrency = originCurrency
            newWallet.walletOriginConvertionCash = originCash
        }
        
        if let ccCurrency = ccCurrency,
           let ccLimit = ccLimit {
            newWallet.walletCreditCardCurrency = ccCurrency
            newWallet.walletCreditCardLimit = ccLimit
        }
        
        wallets.value.append(newWallet)
        
        // For opening balance (money on a wallet)
        let openingBalanceTransaction = Transaction(context: context)
        openingBalanceTransaction.parentWallet = newWallet
        openingBalanceTransaction.transCategory = "Opening Balance"
        openingBalanceTransaction.transType = TransactionType.income.rawValue
        openingBalanceTransaction.transDateTime = creationDate
        openingBalanceTransaction.transAmount = baseCash
        
        transactions.value.append(openingBalanceTransaction)
        
        save()
    }
    
    // MARK: - UPDATE Wallet
    func updateWalletInfo() {
        
    }
    
    // MARK: - DELETE functions for Wallet
    func deleteWallet(for wallet: Wallet) {
        deleteAllTransactions(for: wallet)
        context.delete(wallet)
        wallets.value.removeAll { rmWallet in
            rmWallet == wallet
        }
        save()
    }
}

// MARK: - CRUD Methods for Transactions
extension TralletStorage {
    // MARK: - CREATE Transaction
    
    // MARK: - READ Transactions filtered
    func readTransactions(for wallet: Wallet) -> [Transaction] {
        return transactions.value.filter { transactions in
            transactions.parentWallet == wallet
        }
    }
    
    // MARK: - DELETE Methods for Transaction
    
    // Delete all Transactions for a specific wallet
    func deleteAllTransactions(for wallet: Wallet) {
        let transactionsToDelete = transactions.value.filter { tran in
            tran.parentWallet == wallet
        }
        
        for tdd in transactionsToDelete {
            context.delete(tdd)
        }
        
        transactions.value.removeAll { rmTrans in
            rmTrans.parentWallet == wallet
        }
    }
    
    // Delete specific transaction
    func deleteTransaction(for transaction: Transaction) {
        
    }
}

// MARK: - NSFetchResultsController Delegate Method
extension TralletStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController
        <NSFetchRequestResult>
    ) {
        guard let wallets = controller
                .fetchedObjects as? [Wallet],
              let transactions = controller
                .fetchedObjects as? [Transaction]
        else { return }
        print("Context has changed, reloading wallets and transactions")
        self.wallets.value = wallets
        self.transactions.value = transactions
    }
}
