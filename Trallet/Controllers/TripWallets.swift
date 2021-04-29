//
//  TripWallets.swift
//  Trallet
//
//  Created by Nicholas on 28/04/21.
//

import UIKit

class TripWallets: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletView", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OpenWalletDetail", sender: self)
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    // MARK: - Navigation
    // For the segues that will pass the data back and forth
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

