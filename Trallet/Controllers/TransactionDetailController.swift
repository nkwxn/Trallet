//
//  TransactionDetailController.swift
//  Trallet
//
//  Created by Nicholas on 04/05/21.
//

import UIKit

class TransactionDetailController: UIViewController {
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var transactionNotes: UILabel!
    @IBOutlet weak var transactionLocationImage: UIImageView!
    @IBOutlet weak var transactionLocation: UILabel!
    
    @IBOutlet weak var thumbPaymentMethod: UIImageView!
    @IBOutlet weak var txtPaymentMethod: UILabel!
    
    @IBOutlet weak var thumbIncomeExpense: UIImageView!
    @IBOutlet weak var txtPaymentAmount: UILabel!
    
    @IBOutlet weak var attachmentCollectionView: UICollectionView!
    var arrImages = [UIImage]()
    
    var currencyCode: String!
    var cdTransaction: Transaction!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        numberFormat.minimumFractionDigits = 2
        numberFormat.maximumFractionDigits = 2
//        numberFormat.currencyCode = currencyCode
        
        transactionType.text = cdTransaction.transCategory
        transactionNotes.text = cdTransaction.transNotes ?? ""
        transactionLocation.text = cdTransaction.transLocationKeyword ?? ""
        
        if cdTransaction.transLocationKeyword == nil {
            transactionLocationImage.image = nil
        }
        
        txtPaymentMethod.text = cdTransaction.transPaymentMethod ?? ""
        switch cdTransaction.transPaymentMethod {
        case "Cash":
            thumbPaymentMethod.image = UIImage(systemName: "dollarsign.circle.fill")
        case "Credit Card":
            thumbPaymentMethod.image = UIImage(systemName: "creditcard.circle.fill")
        default:
            thumbPaymentMethod.image = nil
        }
        
        txtPaymentAmount.text = "\(currencyCode!) \(numberFormat.string(from: NSNumber(value: cdTransaction.transAmount))!)"
        thumbIncomeExpense.image = cdTransaction.transType == "Income" ? UIImage(systemName: "plus.circle.fill") : UIImage(systemName: "minus.circle.fill")
        thumbIncomeExpense.tintColor = cdTransaction.transType == "Income" ? UIColor.systemGreen : UIColor.systemRed
        
        arrImages = cdTransaction.transAttachments as? [UIImage] ?? [UIImage]()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: attachmentCollectionView.frame.size.width / 3 - 2, height: attachmentCollectionView.frame.size.width / 3 - 2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        
        attachmentCollectionView.collectionViewLayout = layout
        attachmentCollectionView.delegate = self
        attachmentCollectionView.dataSource = self
    }
    
    @IBAction func btnDonePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
