//
//  TransactionCategoriesController.swift
//  Trallet
//
//  Created by Nicholas on 29/04/21.
//

import UIKit

enum TransactionType: String {
    case income = "Income"
    case expense = "Expense"
}

class TransactionCategoriesController: UITableViewController {
    var newTransaction: NewTransactionController!
    var categoryTableViewCell: UITableViewCell!
    
    let arrCategories = [["Food", "Shopping", "Transport", "Others"], ["Top up"]]
    let arrHeader = ["Expense", "Income"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return arrHeader.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrCategories[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Categories", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = arrCategories[indexPath.section][indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrHeader[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 150, height: CGFloat.leastNormalMagnitude))
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Code to go back and unwind to the tableview cell
        tableView.cellForRow(at: indexPath)?.isSelected = false
        var categoryText: String = ""
        
        if arrCategories[indexPath.section][indexPath.row] == "Others" {
            let alert = UIAlertController(title: "Enter Category", message: "If you have chosen other expense category, please kindly fill the customized category name below:", preferredStyle: .alert)
            alert.addTextField { txtField in
                txtField.placeholder = "Other category"
                txtField.keyboardType = .default
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                // Satan is dead
            })
            alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
                // Push to back
                guard var tfContent = alert.textFields![0].text else { return }
                if tfContent.isEmpty {
                    tfContent = "Others"
                }
                self.categoryTableViewCell.detailTextLabel?.text = "\(self.arrHeader[indexPath.section]): \(tfContent)"
                
                self.navigationController?.popViewController(animated: true)
            })
            self.present(alert, animated: true)
        } else {
            categoryTableViewCell.detailTextLabel?.text = "\(arrHeader[indexPath.section]): \(arrCategories[indexPath.section][indexPath.row])"
            
            navigationController?.popViewController(animated: true)
        }
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
