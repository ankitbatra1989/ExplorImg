//
//  ExploreImagesDetailInteractor.swift
//  ExplorImg
//
//  Created by Ankit Batra on 28/10/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ExploreImagesDetailBusinessLogic: AnyObject {
    func getImage(for imageData: ImageDataModel?, indexPath: IndexPath)
    func getImageFromCache(withUrl imageUrl: String?, indexPath: IndexPath) -> UIImage?
    func scrollToSelectedItem()
}

protocol ExploreImagesDetailDataStore {
    var searchResultsArray : [ImageDataModel]? { get set }
    var pagenumber: Int { get set }
    var selectedIndex: Int { get set }
}

class ExploreImagesDetailInteractor: ExploreImagesDetailBusinessLogic, ExploreImagesDetailDataStore {
    var presenter: ExploreImagesDetailPresentationLogic?
    var worker: ExploreImagesDetailWorker?
    
    var searchResultsArray : [ImageDataModel]?
    var pagenumber: Int = 0
    var selectedIndex: Int = 0

    // MARK: Business Logic
    
    func getImage(for imageData: ImageDataModel?, indexPath: IndexPath) {
        if worker == nil {
            worker = ExploreImagesDetailWorker()
        }
        if let imageURLString = imageData?.largeImageURL, !imageURLString.isEmpty {
            worker?.startOperationsForImage(imageUrl: imageURLString, indexPath: indexPath as NSIndexPath, { [weak self, weak imageData] (isDownloadComplete) in
                    if isDownloadComplete {
                        print("Large ImageDownload Complete for index \(indexPath.item)")
                        imageData?.largeImageState = .Downloaded
                        self?.presenter?.reloadItems(at: [indexPath])
                    }
            })
        }
    }
    
    func getImageFromCache(withUrl imageUrl: String?, indexPath: IndexPath) -> UIImage? {
        if worker == nil {
            worker = ExploreImagesDetailWorker()
        }
        let imageUrlString = imageUrl?.components(separatedBy: "/").last ?? ""
        if let image = worker?.getImageFromCache(imageUrl: imageUrlString, indexPath: indexPath as NSIndexPath) {
            return image
        } else{
           //get from doc directory
            do {
                let manager = FileManager.default
                let documents = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let destinationURL = documents.appendingPathComponent(imageUrlString)
                let image = UIImage(contentsOfFile: destinationURL.path)
                return image
            }
            catch
            {
                NSLog("Error")
            }
        }
        return nil
    }

    func scrollToSelectedItem() {
        presenter?.scrollToItem(indexPath: IndexPath(item: selectedIndex, section: 0))
    }

}
