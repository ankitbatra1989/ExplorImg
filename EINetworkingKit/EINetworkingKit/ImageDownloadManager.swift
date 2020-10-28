//
//  ImageDownloadManager.swift
//  EINetworkingKit
//
//  Created by Ankit Batra on 27/10/20.
//

import UIKit

public class ImageDownloadManager: NSObject {
    
    public static let sharedInstance = ImageDownloadManager()
    public let imageCache = NSCache<NSString,UIImage>()
    public lazy var downloadsInProgress = [NSIndexPath:Operation]()
    public lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Download queue"
        return queue
    }()
    
    
    public func startDownloadForRecord(imageUrl: URL, indexPath: NSIndexPath, _ completion: @escaping (Bool) -> Void) {
        if downloadsInProgress[indexPath] != nil {
            return
        }

        let downloader = DownloadOperation(url: imageUrl)
        downloader.completionBlock = {
            if downloader.isCancelled {
                completion(false)
            }
            DispatchQueue.main.async {
                //Also saving it to NSCache as requested.
                do {
                    let manager = FileManager.default
                    let documents = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let destinationURL = documents.appendingPathComponent("\(imageUrl.lastPathComponent)")
                    guard let image = UIImage(contentsOfFile: destinationURL.path) else {
                        completion(false)
                        return
                    }
                    self.imageCache.setObject(image, forKey: imageUrl.absoluteString as NSString)
                    completion(true)
                }
                catch
                {
                    NSLog("Error")
                }

            }
        }
        downloadsInProgress[indexPath] = downloader
        downloadQueue.addOperation(downloader)
    }
    
    
    func suspendAllOperations() {
        downloadQueue.isSuspended = true
    }

    func resumeAllOperations() {
        downloadQueue.isSuspended = false
    }
    
    public func cancelAllOperations() {
        downloadQueue.cancelAllOperations()
    }

}
