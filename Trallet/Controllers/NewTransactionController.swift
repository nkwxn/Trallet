//
//  NewTransactionController.swift
//  Trallet
//
//  Created by Nicholas on 29/04/21.
//

import UIKit

class NewTransactionController: UITableViewController {
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // Top bar button
    @IBAction func BarButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            // If sender is Done Button, update core data stack
            if sender.isEqual(self.btnDone) {
                
            }
        }
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath)

            // Configure the cell...
            cell.textLabel?.text = "Category"

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTimePicker", for: indexPath) as! DateTimePickerCell

            // Configure the cell...
            cell.category = .dateTimeTransaction

            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath)

            // Configure the cell...
            cell.textLabel?.text = "Location"

            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AmountSpent", for: indexPath)

            // Configure the cell...

            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath)

            // Configure the cell...
            cell.textLabel?.text = "Payment Method"

            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Notes", for: indexPath)

            // Configure the cell...

            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentRow", for: indexPath)

            // Configure the cell...

            return cell
        default:
            let cell = UITableViewCell()

            // Configure the cell...

            return cell
        }
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // Perform segue open the category page
            self.performSegue(withIdentifier: "OpenCategory", sender: self)
        case 2:
            // Now: Show alert pop-up with text field
            let alert = UIAlertController(title: "Enter Location", message: "Please enter some keywords regarding to the location you visited", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "Keyword"
                textField.keyboardType = .default
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
                // Tambahkan interaksi ubah teks di accessory nya
                if let alertInput = alert.textFields![0].text {
                    tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = alertInput
                }
            })
            self.present(alert, animated: true, completion: nil)
            // TODO: In the future put the code to perform segue open the mapview
        case 4:
            // Show Action Sheet for choosing payment method
            let actionSheet = UIAlertController(title: "Choose Payment Method", message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cash", style: .default, handler: { alert in
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = "Cash"
            }))
            actionSheet.addAction(UIAlertAction(title: "Credit Card", style: .default, handler: { alert in
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = "Credit Card"
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        default:
            print("Not identified")
        }
        
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 150, height: CGFloat.leastNormalMagnitude))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 150, height: CGFloat.leastNormalMagnitude))
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier! == "OpenCategory" {
            let dest = segue.destination as! TransactionCategoriesController
            dest.newTransaction = self
            dest.categoryTableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        }
    }

}
