//
//  CoreDataHelper.swift
//  Trallet
//
//  Created by Nicholas on 30/04/21.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    
    // MARK: - Variables (Context and Arrays)
    
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Array of Wallets and Transactions
    var walletsArray = [Wallet]()
    var transactionsArray = [Transaction]()
    
    // DateFormatter to record if this created at the same day
    var dateFormat = DateFormatter()
    var today = Date()
    
    init() {
        load()
        dateFormat.dateStyle = .full
        dateFormat.timeStyle = .none
    }
    
    deinit {
        print("CoreDataHelper is not used anymore")
    }
    
    // MARK: - CREATE Methods for Wallet
    
    // Base: Mata uang yang akan digunakan dalam pencatatan transaksi
    // Origin: Mata uang yang akan digunakan sebagai dasar conversion rate
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
        
        walletsArray.append(newWallet)
        
        // For opening balance (money on a wallet)
        let openingBalanceTransaction = Transaction(context: context)
        openingBalanceTransaction.parentWallet = newWallet
        openingBalanceTransaction.transCategory = "Opening Balance"
        openingBalanceTransaction.transType = TransactionType.income.rawValue
        openingBalanceTransaction.transDateTime = creationDate
        openingBalanceTransaction.transAmount = baseCash
        
        transactionsArray.append(openingBalanceTransaction)
        
        save()
    }
    
    // MARK: - READ Methods for Wallet
    func getSpecificWallet(at index: Int) -> Wallet {
        return walletsArray[index]
    }
    
    // MARK: - UPDATE Methods for Wallet
    func updateWalletBalance(at index: Int, amount: Double) {
        
        save()
    }
    
    // MARK: - DELETE Methods for Wallet
    func deleteWallet(at index: Int) {
        // Delete the transaction relates to the wallet
        deleteTransaction(for: walletsArray[index])
        
        // Delete the wallet and done
        context.delete(walletsArray[index])
        walletsArray.remove(at: index)
        save()
    }
    
    // MARK: - CREATE Methods for Transaction
    func createTransaction(for type: TransactionType, category: String, amount: Double, location: String? = nil, attachments: [UIImage]? = nil) {
        
    }
    
    // MARK: - READ Methods for Transaction
    // Sort and return array
    
    // MARK: - UPDATE Methods for Transaction
    // Ini mending gimana yak...
    
    // MARK: - DELETE Methods for Transaction
    func deleteTransaction(for wallet: Wallet) {
        for (index, transaction) in transactionsArray.enumerated() {
            guard let parentWallet = transaction.parentWallet else { return }
            if parentWallet.isEqual(wallet) {
                context.delete(transactionsArray[index])
                transactionsArray.remove(at: index)
            }
        }
        save()
    }
    
    // MARK: - Load all data to array of Subjects and Schedules
    func load() {
        let transactionRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let walletRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        do {
            walletsArray = try context.fetch(walletRequest)
            transactionsArray = try context.fetch(transactionRequest)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    // MARK: - Save datas after performing CRUD methods.
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
}
