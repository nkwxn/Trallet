//
//  TransactionDetailController.swift
//  Trallet
//
//  Created by Nicholas on 04/05/21.
//

import UIKit
import MapKit

protocol TransactionUpdateDelegate {
    func updateTransactionView(trx: Transaction)
}

class TransactionDetailController: UIViewController {
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var transactionNotes: UILabel!
    @IBOutlet weak var transactionLocationImage: UIImageView!
    @IBOutlet weak var transactionLocation: UILabel!
    @IBOutlet weak var transLocationMap: MKMapView!
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    
    @IBOutlet weak var thumbPaymentMethod: UIImageView!
    @IBOutlet weak var txtPaymentMethod: UILabel!
    
    @IBOutlet weak var thumbIncomeExpense: UIImageView!
    @IBOutlet weak var txtPaymentAmount: UILabel!
    
    @IBOutlet weak var attachmentCollectionView: UICollectionView!
    
    var arrImages = [UIImage]()
    
    var cdWallet: Wallet! {
        didSet {
            currencyCode = cdWallet.walletBaseCurrency
        }
    }
    
    var currencyCode: String!
    
    var cdTransaction: Transaction! {
        didSet {
            arrImages = cdTransaction.transAttachments as? [UIImage] ?? [UIImage]()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
        
        // Collection View Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: attachmentCollectionView.frame.size.width / 3 - 2, height: attachmentCollectionView.frame.size.width / 3 - 2)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        
        // Set collection view layout
        attachmentCollectionView.collectionViewLayout = layout
        attachmentCollectionView.delegate = self
        attachmentCollectionView.dataSource = self
    }
    
    func loadData() {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        numberFormat.minimumFractionDigits = 2
        numberFormat.maximumFractionDigits = 2
//        numberFormat.currencyCode = currencyCode
        
        // Set label for Category and Notes
        transactionType.text = cdTransaction.transCategory
        transactionNotes.text = cdTransaction.transNotes ?? ""
        
        // Transaction Location Text, image and Pinpoint
        transactionLocation.text = cdTransaction.transLocationKeyword ?? ""
        
        // Set the map height to 0 of no keyword
        if cdTransaction.transLocationKeyword == nil && cdTransaction.transLocationItem == nil {
            transactionLocationImage.image = nil
            mapHeight.constant = 0
        } else {
            // Set the pinpoint
            if let pinpoint = cdTransaction.transLocationItem as? MKMapItem {
                let annotation = LocationAnnotation(object: pinpoint)
                transLocationMap.addAnnotation(annotation)
                
                // Set the map zoom
                let coordinate = pinpoint.placemark.coordinate
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.transLocationMap.setRegion(region, animated: true)
            }
        }
        
        // Set payment method image and text
        txtPaymentMethod.text = cdTransaction.transPaymentMethod ?? ""
        switch cdTransaction.transPaymentMethod {
        case "Cash":
            thumbPaymentMethod.image = UIImage(systemName: "dollarsign.circle.fill")
        case "Credit Card":
            thumbPaymentMethod.image = UIImage(systemName: "creditcard.circle.fill")
        default:
            thumbPaymentMethod.image = nil
        }
        
        // Set Payment Amount Text
        txtPaymentAmount.text = "\(currencyCode!) \(numberFormat.string(from: NSNumber(value: cdTransaction.transAmount))!)"
        thumbIncomeExpense.image = cdTransaction.transType == "Income" ? UIImage(systemName: "plus.circle.fill") : UIImage(systemName: "minus.circle.fill")
        thumbIncomeExpense.tintColor = cdTransaction.transType == "Income" ? UIColor.systemGreen : UIColor.systemRed
    }
    
    @IBAction func btnDonePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editTransaction" {
            let navcon = segue.destination as! UINavigationController
            let newTransView = navcon.viewControllers[0] as! NewTransactionController
            newTransView.cdHelper = CoreDataHelper()
//            newTransView.prevDelegate = self
            newTransView.cdWallet = self.cdWallet
            newTransView.transTBU = self.cdTransaction
            
        }
    }
}

extension TransactionDetailController: TransactionUpdateDelegate {
    func updateTransactionView(trx: Transaction) {
        self.cdTransaction = trx
        self.attachmentCollectionView.reloadData()
        self.loadData()
    }
}

extension TransactionDetailController: UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerPreviewingDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrImages.count == 0 {
            collectionView.setEmptyView(text: "No Attachments")
        } else {
            collectionView.restore()
        }
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewcell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! ImageCell
        viewcell.imgView.image = arrImages[indexPath.row]
        return viewcell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    // This view controller that showing
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let previewView = storyboard?.instantiateViewController(identifier: "attachmentPopUp")
        return previewView
    }
    
    // Final view controller
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        print("")
    }
}
