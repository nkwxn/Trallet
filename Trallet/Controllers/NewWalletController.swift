//
//  NewWalletController.swift
//  Trallet
//
//  Created by Nicholas on 29/04/21.
//

import UIKit

class NewWalletController: UITableViewController {
    var walletCollections: TripWallets!
    var cdHelper: CoreDataHelper!
    
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    var goingOverseas: Bool = false
    var planningUseCC: Bool = false
    
    // Variables for Core Data Stack Input
    var thumbBG: UIColor?
    var thumbTxt: String?
    var walletName: String?
    var baseCurrency: String?
    var baseCash: Double?
    var originCurrency: String?
    var originCash: Double?
    var moneyChangedDate: Date?
    var ccCurrency: String?
    var ccLimit: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        thumbBG = #colorLiteral(red: 0.5882352941, green: 0.6078431373, blue: 0.6470588235, alpha: 1)
        thumbTxt = ""
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("View disappeared")
    }
    
    // MARK: - Bar Button Pressed
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        if sender.isEqual(self.btnDone) {
            // Unwrapping the optional value
            if let thumbBG = thumbBG,
               let thumbTxt = thumbTxt,
               let walletName = walletName,
               let baseCurrency = baseCurrency,
               let baseCash = baseCash {
                if !goingOverseas {
                    originCurrency = nil
                    originCash = nil
                    moneyChangedDate = nil
                }
                if !planningUseCC {
                    ccLimit = nil
                    ccCurrency = nil
                }
                self.dismiss(animated: true) {
                    self.cdHelper.createNewWallet(thumbBackground: thumbBG, thumbText: thumbTxt, name: walletName, baseCurrency: baseCurrency, baseCash: baseCash, originCurrency: self.originCurrency, originCash: self.originCash, moneyChangedDate: self.moneyChangedDate, ccCurrency: self.ccCurrency, ccLimit: self.ccLimit)
                    self.walletCollections.tableView.reloadData()
                }
            } else {
                showAlert()
            }
            
        } else {
            self.dismiss(animated: true)
        }
    }

    func showAlert() {
        let alertView = UIAlertController(title: "Unable to create new wallet", message: "Please check all of the required fields", preferredStyle: .alert)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewWalletHeader", for: indexPath) as! NewWalletHeaderCell

            // Configure the cell...
            cell.newWalletView = self
            cell.headerDelegate = self

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchRow", for: indexPath) as! SwitchCell

            // Configure the cell...
            cell.switchEnum = .goingOverseas
            cell.newWalletView = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyAmountInput", for: indexPath) as! AmountMoneyCell

            // Configure the cell...
            cell.enumWallet = .cash
            cell.amountDelegate = self

            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CashExchangedDate", for: indexPath) as! DateTimePickerCell
            cell.category = .dateExchanged
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoingOverseasExchangeRow", for: indexPath) as! MoneyConversionCell

            // Configure the cell...
            cell.conversionDelegate = self
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchRow", for: indexPath) as! SwitchCell

            // Configure the cell...
            cell.switchEnum = .planUseCC
            cell.newWalletView = self
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyAmountInput", for: indexPath) as! AmountMoneyCell

            // Configure the cell...
            cell.enumWallet = .cc
            cell.amountDelegate = self

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
            // Date Picker
//            return goingOverseas ? 57 : 0.0
            return 0
        case 4:
            return goingOverseas ? 225 : 0
        case 6:
            return planningUseCC ? 85.0 : 0
        default:
            return 53.0
        }

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 150, height: CGFloat.leastNormalMagnitude))
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 150, height: CGFloat.leastNormalMagnitude))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "changeImage":
            let dest = segue.destination as! UINavigationController
            let thumb = dest.viewControllers[0] as! WalletThumbnailController
            let firstRow = self.tableView.visibleCells[0] as! NewWalletHeaderCell
            thumb.newWalletView = self
            thumb.bgColor = firstRow.bgThumbnail.backgroundColor
            thumb.thumb = firstRow.lblThumbnail.text
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

// MARK: - Extension for Delegate Methods

extension NewWalletController: NewWalletHeaderDelegate, AmountMoneyDelegate, MoneyConversionDelegate {
    
    // Getting the conversion data
    func moneyConversionStack(baseCurrency: String?, baseAmount: Double?, originCurrency: String?, originAmount: Double?) {
        self.baseCurrency = baseCurrency
        self.baseCash = baseAmount
        self.originCurrency = originCurrency
        self.originCash = originAmount
    }
    
    func sendData(_ walletStatus: WalletStatusType, currencyCode: String?, amount: Double?) {
        switch walletStatus {
        case .cash:
            baseCurrency = currencyCode!
            baseCash = amount ?? nil
            print(baseCurrency!)
        case .cc:
            ccCurrency = currencyCode!
            ccLimit = amount!
        }
    }
    
    func passWalletName(walletName name: String?) {
        self.walletName = name
    }
    
}
