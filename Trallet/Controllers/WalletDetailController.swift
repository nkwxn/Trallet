//
//  WalletDetailController.swift
//  Trallet
//
//  Created by Nicholas on 29/04/21.
//

import UIKit

class WalletDetailController: UITableViewController {
    var cdHelper: CoreDataHelper!
    var cdWallet: Wallet! {
        didSet {
            // Get all of the data
            print(cdWallet!)
            self.navigationItem.title = cdWallet.walletName
        }
    }
    let nf = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        
        registerViewsToTableView()
    }
    
    private func registerViewsToTableView() {
        tableView.register(UINib(nibName: "TransactionHistoryCell", bundle: nil), forCellReuseIdentifier: TransactionHistoryCell.ReuseID())
        tableView.register(UINib(nibName: "TransactionHistoryHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: TransactionHistoryHeader.ReuseID())
        tableView.register(UINib(nibName: "TransactionFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: TransactionHistoryFooter.ReuseID())
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cdHelper.getTransactionsHeader(for: cdWallet).count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if cdWallet.walletCreditCardCurrency == nil && cdWallet.walletCreditCardExpense == 0 {
                return 2
            } else {
                return 3
            }
        default:
            // Jumlah cell tiap section dengan array of transactionhistory bds tanggal (sorting jan lupa)
            return cdHelper.readAllTransactions(for: cdWallet)[section - 1].count
        }
    }
    
    func showWalletStatus(_ walletStat: WalletStatusType, data cdWallet: Wallet, forRow indexPath: IndexPath) -> WalletStatusCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletStatusCell", for: indexPath) as! WalletStatusCell
        cell.nf = NumberFormatter()
        cell.enumWalletStat = walletStat
        cell.cdWallet = cdWallet
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // First section which contains status
        case 0:
            if cdWallet.walletCreditCardCurrency == nil && cdWallet.walletCreditCardExpense == 0 {
                print("Should show only wallet status")
                switch indexPath.row {
                case 0:
                    return showWalletStatus(.cash, data: cdWallet, forRow: indexPath)
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHistoryTitleHeader", for: indexPath)
                    return cell
                }
            } else {
                // Show both but depends
                switch indexPath.row {
                case 0:
                    return showWalletStatus(.cash, data: cdWallet, forRow: indexPath)
                case 1:
                    return showWalletStatus(.cc, data: cdWallet, forRow: indexPath)
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHistoryTitleHeader", for: indexPath)
                    return cell
                }
            }
            
        // The rest of other sections which consists of cell transaction history.
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionHistoryCell.ReuseID()) as! TransactionHistoryCell
            
            cell.cdTransaction = cdHelper.readAllTransactions(for: cdWallet)[indexPath.section - 1][indexPath.row]
            
            return cell
        }
    }
    
    // MARK: - TableView Section Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView(frame: CGRect(x: 0, y: 0, width: 150, height: CGFloat.leastNormalMagnitude))
        default:
            // Return custom header based on the sorting
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TransactionHistoryHeader.ReuseID()) as! TransactionHistoryHeader
            header.transactionDate = cdHelper.getTransactionsHeader(for: cdWallet)[section-1]
            return header
//            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNonzeroMagnitude
        default:
            return 50
        }
    }
    
    // MARK: - TableView Section Footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView(frame: CGRect(x: 0, y: 0, width: 150, height: CGFloat.leastNormalMagnitude))
        default:
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: TransactionHistoryFooter.ReuseID())
            return footer
//            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNonzeroMagnitude
        default:
//            return CGFloat.leastNonzeroMagnitude
            return tableView.sectionFooterHeight
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "OpenNewTrasaction" {
            let navcon = segue.destination as! UINavigationController
            let newTransView = navcon.viewControllers[0] as! NewTransactionController
            newTransView.cdHelper = self.cdHelper
            newTransView.previousPage = self
            newTransView.cdWallet = self.cdWallet
        }
    }
    
}
