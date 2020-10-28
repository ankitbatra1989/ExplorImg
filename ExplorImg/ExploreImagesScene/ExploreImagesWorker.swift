//
//  ExploreImagesWorker.swift
//  ExplorImg
//
//  Created by Ankit Batra on 25/10/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import EINetworkingKit

class ExploreImagesWorker {
        
    let downloadManager = ImageDownloadManager.sharedInstance
    
    func searchPixabayForImagesWith(keyword searchText:String, pageNumber: Int, _ completion: @escaping (Result<ImageContainerModel?, Error>) -> Void)
    {
        EICodableTask.getImagesFromPixabay(searchText,pageNumber) { (result) in
            completion(result)
        }.urlDataTask?.resume()
    }
    
    func startOperationsForImage(imageUrl: String?, indexPath: NSIndexPath, _ completion: @escaping (Bool) -> Void) {
        if let imageURLString = imageUrl, let imageUrl = URL(string: imageURLString) {
            downloadManager.startDownloadForRecord(imageUrl: imageUrl, indexPath: indexPath, completion)
        }
    }
    
    func getImageFromCache(imageUrl: String, indexPath: NSIndexPath) -> UIImage? {
        return downloadManager.imageCache.object(forKey:imageUrl as NSString)
    }
    
    func getPendingOperations() -> Set<NSIndexPath>  {
        return Set(downloadManager.downloadsInProgress.keys)
    }
    
    func removeOperationsInProgess( cancelledIndexPaths: Set<NSIndexPath>) {
        for indexPath in cancelledIndexPaths {
            if let pendingDownload = downloadManager.downloadsInProgress[indexPath] {
                pendingDownload.cancel()
            }
            downloadManager.downloadsInProgress.removeValue(forKey:indexPath)
        }
    }
    
    func suspendAllOperations () {
        downloadManager.downloadQueue.isSuspended = true
    }

    func resumeAllOperations () {
        downloadManager.downloadQueue.isSuspended = false
    }
    
    func cancelAllOperations() {
        downloadManager.cancelAllOperations()
        downloadManager.downloadsInProgress.removeAll()

    }
}
