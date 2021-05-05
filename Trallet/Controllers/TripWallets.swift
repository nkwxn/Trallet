//
//  TripWallets.swift
//  Trallet
//
//  Created by Nicholas on 28/04/21.
//

import UIKit

class TripWallets: UITableViewController {
    var cdHelper = CoreDataHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cdHelper.load()
        tableView.reloadData()
    }

    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Empty state
        switch cdHelper.walletsArray.count {
        case 0:
            tableView.setEmptyView(title: "Traveling really soon? 🛫", message: "Add your new travel wallet by clicking the + button on the top-right corner")
        default:
            tableView.restore()
        }
        
        return cdHelper.walletsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletView", for: indexPath) as! WalletCell

        // Configure the cell...
        cell.cdWallet = cdHelper.walletsArray[indexPath.row]

        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OpenWalletDetail", sender: self)
//        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            // TODO: Masukkan query delete disini
            cdHelper.deleteWallet(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
            print(cdHelper.walletsArray)
        }
    }
    
    // MARK: - Navigation
    // For the segues that will pass the data back and forth
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addNewWallet":
            // Data yg perlu di pass: CDHelper, this view (biar bs reload tableviewcell after adding wallet)
            let navCon = segue.destination as! UINavigationController
            let newWallet = navCon.viewControllers[0] as! NewWalletController
            
            newWallet.walletCollections = self
            newWallet.cdHelper = self.cdHelper
        case "OpenWalletDetail":
            let dest = segue.destination as! WalletDetailController
            dest.cdHelper = self.cdHelper
            guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            dest.cdWallet = cdHelper.getSpecificWallet(at: indexPath.row) // Get this from selected row
        default:
            print("Error: Segue not identified for data transfer")
        }
    }
}

