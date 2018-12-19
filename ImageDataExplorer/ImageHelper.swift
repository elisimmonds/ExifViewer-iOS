/*
 *  ImageHelper.swift
 *  ImageDataExplorer
 *
 *  Created by Eli Simmonds on 12/18/18.
 */

import Foundation
import ImageIO
import Photos

class ImageHelper {
    func saveToPhotoLibrary_iOS9(data:NSData, completionHandler: @escaping (PHAsset?)->()) {
        var assetIdentifier: String?
        PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) in
            if(status == PHAuthorizationStatus.authorized){
                
                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    let placeholder = creationRequest.placeholderForCreatedAsset
                    
                    creationRequest.addResource(with: PHAssetResourceType.photo, data: data as Data, options: nil)
                    assetIdentifier = placeholder?.localIdentifier
                    
                }, completionHandler: { (success, error) in
                    if let error = error {
                        print("There was an error saving to the photo library: \(error)")
                    }
                    
                    var asset: PHAsset? = nil
                    if let assetIdentifier = assetIdentifier{
                        asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil).firstObject//fetchAssetsWithLocalIdentifiers([assetIdentifier], options: nil).firstObject as? PHAsset
                    }
                    completionHandler(asset)
                })
            }else {
                print("Need authorisation to write to the photo library")
                completionHandler(nil)
            }
        }
    }
}
