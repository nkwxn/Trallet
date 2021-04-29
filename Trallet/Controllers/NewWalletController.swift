//
//  NewWalletController.swift
//  Trallet
//
//  Created by Nicholas on 29/04/21.
//

import UIKit

class NewWalletController: UITableViewController {
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    var goingOverseas: Bool = false
    var planningUseCC: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Bar Button Pressed
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            // TODO: If button pressed done, create new wallet on Core Data Stack
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewWalletHeader", for: indexPath) as! NewWalletHeaderCell

            // Configure the cell...
            cell.newWalletView = self

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchRow", for: indexPath) as! SwitchCell

            // Configure the cell...
            cell.switchEnum = .goingOverseas
            cell.newWalletView = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CashExchangedDate", for: indexPath)

            // Configure the cell...
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoingOverseasExchangeRow", for: indexPath)

            // Configure the cell...
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchRow", for: indexPath) as! SwitchCell

            // Configure the cell...
            cell.switchEnum = .planUseCC
            cell.newWalletView = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyAmountInput", for: indexPath)

            // Configure the cell...

            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200.0
        case 2:
            return goingOverseas ? 0.0 : 85.0
        case 3:
            return goingOverseas ? 57 : 0.0
        case 4:
            return goingOverseas ? 225 : 0
        case 6:
            return planningUseCC ? 85.0 : 0
        default:
            return 53.0
        }

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    /*
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
 */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "changeImage":
            let dest = segue.destination as! UINavigationController
            let thumb = dest.viewControllers[0] as! WalletThumbnailController
            thumb.newWalletView = self
        default:
            print("Segue not identified")
        }
    }
    
    func changeThumb(thumb: String, bg: UIColor) {
        let firstRow = self.tableView.visibleCells[0] as! NewWalletHeaderCell
        
        firstRow.bgThumbnail.backgroundColor = bg
        firstRow.lblThumbnail.text = thumb
    }

}
