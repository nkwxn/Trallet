//
//  AttachmentCell.swift
//  Trallet
//
//  Created by Nicholas on 03/05/21.
//

import UIKit

class AttachmentCell: UITableViewCell {
    @IBOutlet weak var btnAddImages: UIButton!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    var relatedView: NewTransactionController? {
        didSet {
            delegate = relatedView
        }
    }
    var delegate: AttachmentCellDelegate?
    
    @IBOutlet weak var imgPickerHeight: NSLayoutConstraint!
    
    var imagePicker = UIImagePickerController()
    var imgArray: [UIImage]? = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: imgCollectionView.frame.size.width / 4 - 2, height: imgCollectionView.frame.size.width / 4 - 2)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumInteritemSpacing = 1
        
        imgPickerHeight.constant = imgCollectionView.frame.size.width / 4 - 2
        
        imagePicker.delegate = self
        imgCollectionView.delegate = self
        imgCollectionView.dataSource = self
        imgCollectionView.collectionViewLayout = layout
    }

    @IBAction func btnAddPressed(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Add images from", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default) { action in
            // Open the image selector
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.relatedView?.present(self.imagePicker, animated: true, completion: nil)
        })
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { action in
            // Open the camera
            self.imagePicker.sourceType = .camera
            self.relatedView?.present(self.imagePicker, animated: true, completion: nil)
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        relatedView?.present(actionSheet, animated: true)
    }
}

// Delegate Methods
extension AttachmentCell: UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Image Picker Controller Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imgArray?.append(image)
            print(imgArray!)
            delegate?.sendAttachments(imgArray)
        } else if let image = info[.originalImage] as? UIImage {
            imgArray?.append(image)
            print(imgArray!)
            delegate?.sendAttachments(imgArray)
        }
        imagePicker.dismiss(animated: true) {
            self.imgCollectionView.reloadData()
            self.relatedView?.tableView.beginUpdates()
            self.relatedView?.tableView.endUpdates()
        }
    }
    
    // MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // The empty state
        if imgArray?.count == 0 {
            collectionView.setEmptyView(text: "No Images Chosen")
        } else {
            collectionView.restore()
        }
        
        return imgArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.backgroundColor = UIColor(named: "AccentColor")
        cell.imgView.image = imgArray?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Show an alert reminding if sure to delete
        let actionDelete = UIAlertController(title: "Remove Attachment", message: "Are you sure you want to remove this picture?", preferredStyle: .alert)
        actionDelete.addAction(UIAlertAction(title: "Remove", style: .destructive) { alertRemove in
            self.imgArray?.remove(at: indexPath.row)
            self.imgCollectionView.reloadData()
        })
        actionDelete.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.relatedView?.present(actionDelete, animated: true)
    }
}

protocol AttachmentCellDelegate {
    func sendAttachments(_ images: [UIImage]?)
}

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 8
        borderView.layer.borderColor =  UIColor(named: "AccentColor")?.cgColor
        
    }
}
