//
//  NewTransactionController.swift
//  Trallet
//
//  Created by Nicholas on 29/04/21.
//

import UIKit
import MapKit

class NewTransactionController: UITableViewController {
    // Data passed when done button pressed
    // Mandatory data
    var type: TransactionType?
    var category: String?
    var dateTime: Date? = Date()
    var amountMoney: Double?
    var paymentType: WalletStatusType? // can be used for payment type
    
    // Optional Value
    var locationItem: MKMapItem? {
        didSet {
            locationKeyword = locationItem?.name
        }
    }
    var locationKeyword: String? {
        didSet {
            let rowTV = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))
            rowTV?.detailTextLabel?.text = locationKeyword
        }
    }
    var notes: String?
    var attachments: [UIImage]?
    
    // Data passed through and set into a controller
    var previousPage: WalletDetailController!
    var cdHelper: CoreDataHelper!
    var cdWallet: Wallet! {
        didSet {
            print(cdWallet!)
        }
    }
    
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
        if sender.isEqual(self.btnDone) {
            // If any field is empty, show alert message unable to add new transaction
            if self.type == .income {
                self.paymentType = .cash
            }
            
            if let safeType = self.type,
               let safeCategory = self.category,
               let safeDateTime = self.dateTime,
               let safeAmount = self.amountMoney,
               let safePaymentMethod = self.paymentType {
                
                self.cdHelper.createTransaction(
                    self.cdWallet,
                    for: safeType,
                    category: safeCategory,
                    date: safeDateTime,
                    amount: safeAmount,
                    paymentMethod: safePaymentMethod,
                    location: self.locationKeyword,
                    note: self.notes,
                    attachments: self.attachments
                )
                
                self.dismiss(animated: true) {
                    self.previousPage.tableView.reloadData()
                }
                
            } else {
                showAlert()
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
    // Show the alert
    func showAlert() {
        let alertView = UIAlertController(title: "Unable to create new transaction", message: "Please check all of the required fields", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Okay", style: .default))
        self.present(alertView, animated: true)
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
            cell.pickerDelegate = self

            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath)

            // Configure the cell...
            cell.textLabel?.text = "Location"

            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AmountSpent", for: indexPath) as! TransactionAmountSpentCell

            // Configure the cell...
            cell.delegate = self
            cell.cdWallet = self.cdWallet

            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath)

            // Configure the cell...
            cell.textLabel?.text = "Payment Method"

            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Notes", for: indexPath) as! TransactionNotesCell

            // Configure the cell...
            cell.delegate = self

            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentRow", for: indexPath) as! AttachmentCell

            // Configure the cell...
            cell.relatedView = self
//            cell.delegate = self

            return cell
        default:
            let cell = UITableViewCell()

            // Configure the cell...

            return cell
        }
    }
    
    // atur row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 4:
            return type == .income ? 0 : tableView.estimatedRowHeight
        default:
            return tableView.estimatedRowHeight
        }
    }
    
    // MARK: - Unwind from Category
    func unwindFromCategory(for transactionType: TransactionType, catName: String) {
        self.type = transactionType
        self.category = catName
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // Perform segue open the category page
            self.performSegue(withIdentifier: "OpenCategory", sender: self)
        case 2:
            /*
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
                    
                    self.locationKeyword = alertInput
                }
            })
            self.present(alert, animated: true, completion: nil)
            */
            
            // TODO: In the future put the code to perform segue open the mapview
            self.performSegue(withIdentifier: "openMap", sender: self)
        case 4:
            // Show Action Sheet for choosing payment method
            let actionSheet = UIAlertController(title: "Choose Payment Method", message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cash", style: .default, handler: { alert in
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = "Cash"
                self.paymentType = .cash
            }))
            actionSheet.addAction(UIAlertAction(title: "Credit Card", style: .default, handler: { alert in
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = "Credit Card"
                self.paymentType = .cc
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
        } else if segue.identifier! == "openMap" {
            let dest = segue.destination as! SelectLocationViewController
            dest.delegate = self
        }
    }

}

extension NewTransactionController: DateTimeCategoryDelegate, TransactionAmountDelegate, TransactionNotesDelegate, AttachmentCellDelegate {
    
    func sendAttachments(_ images: [UIImage]?) {
        self.attachments = images
    }
    
    // Date and time delegate
    func fetchDateTime(_ dateTime: Date) {
        self.dateTime = dateTime
    }
    
    // Amount delegate
    func transactionAmount(number: Double?) {
        self.amountMoney = number
    }
    
    // Notes delegate
    func transactionNote(_ note: String?) {
        self.notes = note
    }
    
    // Attachments cell delegate to import images
    func sendAttachments(_ images: [UIImage]) {
        self.attachments = images
    }
}

extension NewTransactionController: SelectLocationDelegate {
    func locationSelected(_ location: MKMapItem) {
        print(location)
        self.locationKeyword = location.name
    }
}
