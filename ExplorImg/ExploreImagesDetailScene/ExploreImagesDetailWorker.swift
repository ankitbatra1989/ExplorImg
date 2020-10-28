//
//  ExploreImagesDetailWorker.swift
//  ExplorImg
//
//  Created by Ankit Batra on 28/10/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import EINetworkingKit

class ExploreImagesDetailWorker {
    
    let downloadManager = ImageDownloadManager.sharedInstance
    
    func startOperationsForImage(imageUrl: String?, indexPath: NSIndexPath, _ completion: @escaping (Bool) -> Void) {
        if let imageURLString = imageUrl, let imageUrl = URL(string: imageURLString) {
            downloadManager.downloadsInProgress.removeAll()
            downloadManager.cancelAllOperations()
            downloadManager.startDownloadForRecord(imageUrl: imageUrl, indexPath: indexPath, completion)
        }
    }
    
    func getImageFromCache(imageUrl: String, indexPath: NSIndexPath) -> UIImage? {
        return downloadManager.imageCache.object(forKey:imageUrl as NSString)
    }
}
