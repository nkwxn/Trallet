//
//  WalletListTableViewController.swift
//  Trallet
//
//  Created by Nicholas on 01/01/22.
//

import UIKit

enum CustomRowNames: String {
    case WalletRowTableViewCell
}

class WalletListTableViewController: UITableViewController {
    var viewModel = WalletListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView(frame: self.view.frame, style: .insetGrouped)
        tableView.register(UINib(nibName: CustomRowNames.WalletRowTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: CustomRowNames.WalletRowTableViewCell.rawValue)
        
        self.tableView = tableView
        self.setCustomBackgroundColor()

        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        self.title = "My Trip Wallets"
        setBarButton()
    }
    
    private func setBarButton() {
        if #available(iOS 14.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Wallet", image: UIImage(systemName: "plus"), primaryAction: nil, menu: nil)
        } else {
            // Fallback on earlier versions
            let barItem = UIBarButtonItem()
            barItem.title = "Add Wallet"
            barItem.image = UIImage(systemName: "plus")
            self.navigationItem.rightBarButtonItem = barItem
        }
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
}

// MARK: - TableView Delegate and DataSource
extension WalletListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Wallets"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomRowNames.WalletRowTableViewCell.rawValue, for: indexPath) as? WalletRowTableViewCell else { fatalError("WalletRow is not found") }
        cell.walletNameLbl.text = "Wallet \(indexPath.row)"
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    // Leading Swipe Actions
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markAsFavAction = UIContextualAction(
            style: .normal,
            title: "Mark as Favorite"
        ) { [weak self] action, view, completionHandler in
            self?.viewModel.handleStarWallet()
            completionHandler(true)
        }
        markAsFavAction.backgroundColor = .systemYellow
        markAsFavAction.image = UIImage(systemName: "star.fill")
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [markAsFavAction])
        return swipeActionConfig
    }
    
    // Trailing Swipe Actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] action, view, completionHandler in
            self?.viewModel.handleDeleteWallet()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionConfig
    }
}
