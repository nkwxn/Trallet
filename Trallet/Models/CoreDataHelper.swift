//
//  CoreDataHelper.swift
//  Trallet
//
//  Created by Nicholas on 30/04/21.
//

import Foundation
import UIKit
import CoreData
import MapKit

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
    func updateWalletInfo() {
        
    }
    
    func updateWalletBalance(_ type: TransactionType, at index: Int, amount: Double) {
        let wallet = walletsArray[index]
        switch type {
        case .expense:
            let balance = wallet.walletBaseBalance - amount
            wallet.walletBaseBalance = balance
        case .income:
            let balance = wallet.walletBaseBalance + amount
            wallet.walletBaseBalance = balance
        }
        save()
    }
    
    func updateWalletBalance(_ type: TransactionType, for wallet: Wallet, amount: Double) {
        for (i, wal) in walletsArray.enumerated() {
            if wal.isEqual(wallet) {
                // update the wallet balance
                updateWalletBalance(type, at: i, amount: amount)
                // update the total income / expense
                updateTotal(type, at: i, amount: amount)
            }
        }
    }
    
    func updateTotal(_ type: TransactionType, at index: Int, amount: Double) {
        let wallet = walletsArray[index]
        switch type {
        case .expense:
            let total = wallet.walletCashTotalExpense + amount
            wallet.walletCashTotalExpense = total
        case .income:
            let total = wallet.walletCashTotalIncome + amount
            wallet.walletCashTotalIncome = total
        }
        save()
    }
    
    func updateCCExpense(_ type: TransactionType, for wallet: Wallet, amount: Double) {
        for (i, wal) in walletsArray.enumerated() {
            if wal.isEqual(wallet) {
                let wallet = walletsArray[i]
                wallet.walletCreditCardExpense += amount
            }
        }
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
    func createTransaction(_ wallet: Wallet, for type: TransactionType, category: String, date transactionDate: Date, amount: Double, paymentMethod method: WalletStatusType, location: MKMapItem? = nil, note: String? = nil, attachments: [UIImage]? = nil) {
        let newTransaction = Transaction(context: context)
        
        // Mandatory fields
        newTransaction.transType = String(type.rawValue)
        newTransaction.transCategory = category
        newTransaction.transDateTime = transactionDate
        newTransaction.parentWallet = wallet
        newTransaction.transAmount = amount
        
        newTransaction.transNotes = note
        
        if type == .expense {
            newTransaction.transPaymentMethod = method.rawValue
        } else {
            newTransaction.transPaymentMethod = nil
        }
        
        if let attachments = attachments {
            newTransaction.transAttachments = attachments as NSObject
        }
        
        if let location = location {
            newTransaction.transLocationItem = location
            newTransaction.transLocationKeyword = location.name
        }
        
        // Update Balance, Total Transaction, and / or CC Limit
        switch method {
        case .cash:
            updateWalletBalance(type, for: wallet, amount: amount)
        case .cc:
            updateCCExpense(type, for: wallet, amount: amount)
        }
        
        transactionsArray.append(newTransaction)
        save()
    }
    
    // MARK: - READ Methods for Transaction
    // Sort and return array
    func getTransactionsHeader(for wallet: Wallet) -> [Date] {
        var header = [Date]()
        
        // Looping the original transaction header
        transactionsArray.sort { left, right in
            guard let leftDate = left.transDateTime else { return true }
            guard let rightDate = right.transDateTime else { return true }
            return leftDate < rightDate
        }
        
        for tran in transactionsArray {
            guard let safeParent = tran.parentWallet else { return header }
            if safeParent.isEqual(wallet) {
                guard let dateTime = tran.transDateTime else { return header }
                
                if let lastIndex = header.last {
                    if dateFormat.string(from: lastIndex) != dateFormat.string(from: dateTime) {
                        header.append(dateTime)
                    }
                } else {
                    header.append(dateTime)
                }
            }
        }
        return header
    }
    
    func readAllTransactions(for wallet: Wallet) -> [[Transaction]]  {
        var transaction = [[Transaction]]()
        
        // Looping the original transaction header
        transactionsArray.sort { left, right in
            guard let leftDate = left.transDateTime else { return true }
            guard let rightDate = right.transDateTime else { return true }
            return leftDate < rightDate
        }
        
        var tranDaily = [Transaction]()
        let transactionHeader = self.getTransactionsHeader(for: wallet)
        var currentDateIndex = 0
        
        for tran in transactionsArray {
            if wallet.isEqual(tran.parentWallet) {
                if let tranDate = tran.transDateTime {
                    if dateFormat.string(from: transactionHeader[currentDateIndex]) == dateFormat.string(from: tranDate) {
                        tranDaily.append(tran)
                    } else {
                        transaction.append(tranDaily)
                        currentDateIndex += 1
                        tranDaily.removeAll()
                        tranDaily.append(tran)
                    }
                }
            }
        }
        
        transaction.append(tranDaily)
        
        return transaction
    }
    
    // MARK: - UPDATE Methods for Transaction
    func updateTransaction() {
        
    }
    
    // MARK: - DELETE Methods for Transaction
    func deleteTransaction(for wallet: Wallet) {
        let transactionRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        let predicate = NSPredicate(format: "parentWallet.walletName MATCHES %@", wallet.walletName!)
        
        transactionRequest.predicate = predicate

        var sortedTransactions = [Transaction]()
        
        do {
            sortedTransactions = try context.fetch(transactionRequest)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        for transaction in sortedTransactions {
            guard let parentWallet = transaction.parentWallet else { return }
            if parentWallet.isEqual(wallet) {
                context.delete(sortedTransactions.last!)
                sortedTransactions.removeLast()
            }
        }
        
        save()
        
        load()
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
