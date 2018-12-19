/*
 *  ViewController.swift
 *  ImageDataExplorer
 *
 *  Created by Eli Simmonds on 12/5/18.
 */

import UIKit
import Photos
import SnapKit

class LandingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let imagePicker = UIImagePickerController()
    let imageView = UIImageView()
    let pickerLabel = UILabel()
    let exifButton = UIButton()
    let shareButton = UIButton()
    var exifData: [UIImagePickerController.InfoKey : Any]?
    let instagramURL = URL(string: "instagram://app")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "EXIF Explorer"
        
        setupSubviews()
        createConstraints()
    }
    
    private func setupSubviews() -> Void {
        imageView.image = UIImage(named: "imagePlaceholder")
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 10.0
        imageView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        imageView.layer.shadowRadius = 5.0
        imageView.layer.shadowOpacity = 0.5
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        imageView.addGestureRecognizer(tap)
        self.view.addSubview(imageView)
        
        exifButton.setTitle("EXIF Data", for: .normal)
        exifButton.setTitleColor(.black, for: .normal)
        exifButton.titleLabel?.textAlignment = .center
        let openExifViewer = UITapGestureRecognizer(target: self, action: #selector(openExifDataViewer))
        exifButton.addGestureRecognizer(openExifViewer)
        self.view.addSubview(exifButton)
        
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.titleLabel?.textAlignment = .center
        let btnTap = UITapGestureRecognizer(target: self, action: #selector(shareContent(sender:)))
        shareButton.addGestureRecognizer(btnTap)
        self.view.addSubview(shareButton)
    }
    
    private func createConstraints() -> Void {
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0) + 30)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(UIScreen.main.bounds.width * 0.50)
        }
        
//        pickerLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(imageView.snp.bottom).offset(30)
//            make.width.equalToSuperview()
//            make.height.equalTo(30)
//        }
        
        exifButton.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.top.equalTo(exifButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
    }

    func openPicker() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have perission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func tapFunction() -> Void {
        print("tapFunction")
        let status = PHPhotoLibrary.authorizationStatus()
        switch status{
        case .authorized:
            openPicker()
            break
        case .denied, .restricted:
            print("Denied")
            break
        case .notDetermined:
            print("Not yet determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
               self.openPicker()
            })
            break
        default:
            break
        }
    }
}

extension LandingViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePickedAction(info: info)
    }
    
    private func imagePickedAction(info: [UIImagePickerController.InfoKey: Any]) -> Void {
        self.exifData = info
        
        if let pickedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = pickedImg
        } else if let pickedImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = pickedImg
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func openExifDataViewer() -> Void {
        print("opening exif data viewer")
        guard let info = exifData else { return }
        guard let assetURL = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL else {
            print("ERROR!")
            dismiss(animated: true, completion: nil)
            return
        }
        let asset = PHAsset.fetchAssets(withALAssetURLs: [assetURL as URL], options: nil)
        guard let result = asset.firstObject else {
            return
        }
        
        let imageManager = PHImageManager.default()
        imageManager.requestImageData(for: result , options: nil, resultHandler:{
            (data, responseString, imageOriet, info) -> Void in
            let imageData: NSData = data! as NSData
            if let imageSource = CGImageSourceCreateWithData(imageData, nil) {
                //                print("imageProperties2: ", imageProperties2)
                let imageProperties2 = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)! as NSDictionary
                let data = DetailData(title: "Image Details", data: imageProperties2)
                let detailController = ImageDetailViewController(data: data)
                self.navigationController?.pushViewController(detailController, animated: true)
            }
            
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func shareContent(sender: UIButton) {
        
        guard let instagramURL = instagramURL else {
            print("Invalid url \(String(describing: self.instagramURL))")
            return
        }
        
        if UIApplication.shared.canOpenURL(instagramURL) == false {
            print("Instagram not found")
        }
        
        let image = UIImage() 
        let objectsToShare: [AnyObject] = [ image ]
//        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
//        self.present(activityViewController, animated: true, completion: nil)
    }
}
