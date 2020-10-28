//
//  ExploreImagesInteractor.swift
//  ExplorImg
//
//  Created by Ankit Batra on 25/10/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ExploreImagesBusinessLogic: AnyObject {
    func getDataFromPixabay(forSearchText searchText:String?)
    func loadImagesForOnscreenCells(_ indexPathsForVisibleItems: [IndexPath])
    func getImage(for imageData: ImageDataModel?, indexPath: IndexPath)
    func getImageFromCache(withUrl imageUrl: String?, indexPath: IndexPath) -> UIImage?
    func suspendAllOperations()
    func resumeAllOperations()
    func setSelectedIndex(_ index: Int)
}

protocol ExploreImagesDataStore {
    //var name: String { get set }
    var searchResultsArray : [ImageDataModel]? { get set }
    var pagenumber: Int { get set }
    var isLoadingNewData: Bool { get set }
    var selectedIndex: Int { get set }
    var successfullySearchedStrings: [String] { get set }

}

class ExploreImagesInteractor: ExploreImagesBusinessLogic, ExploreImagesDataStore {
    var selectedIndex: Int = 0
    var presenter: ExploreImagesPresentationLogic?
    var worker: ExploreImagesWorker?
    var searchResultsArray : [ImageDataModel]?
    var pagenumber: Int = 0
    var isLoadingNewData: Bool = false
    var currentSearchbarText: String?
    var successfullySearchedStrings: [String] = []

    
    // MARK: Business Logic
    
    func getDataFromPixabay(forSearchText searchText:String?=nil) {
        if self.searchResultsArray == nil {
            self.searchResultsArray = []
        }
        if let searchbarText = searchText {
            // called for a new search
            worker?.cancelAllOperations()
            pagenumber = 0
            currentSearchbarText = searchbarText
        }
        guard let currentSearchbarText = currentSearchbarText else {
            return
        }
        pagenumber += 1
        isLoadingNewData = true
        //
        worker = ExploreImagesWorker()
        worker?.searchPixabayForImagesWith(keyword: currentSearchbarText,pageNumber: pagenumber, { [weak self, pagenumber] (result) in
            guard let imagesArrayData = try? result.get(), let imagesArray = imagesArrayData.hits, !imagesArray.isEmpty else {
                    // API Error - Try again or show error
                print("Error fetching images from Pixabay")
                self?.presenter?.showError()
                return
            }
            print("Images Fetched from Pixabay \n \(imagesArray)")
            if pagenumber == 1 {
                self?.searchResultsArray?.removeAll()
                self?.successfullySearchedStrings.append(currentSearchbarText)
            }
            self?.searchResultsArray?.append(contentsOf: imagesArray)
            self?.isLoadingNewData = false
            self?.presenter?.reloadCollectionView()
        })
    }
    
    func getImage(for imageData: ImageDataModel?, indexPath: IndexPath) {
        if let imageURLString = imageData?.previewURL, !imageURLString.isEmpty {
            worker?.startOperationsForImage(imageUrl: imageURLString, indexPath: indexPath as NSIndexPath, { [weak self, weak imageData] (isDownloadComplete) in
                print("Preview ImageDownload Complete for index \(indexPath.item)")
                    if isDownloadComplete {
                        imageData?.imageState = .Downloaded
                        self?.presenter?.reloadItems(at: [indexPath])
                    }
            })
        }
    }
    
    func getImageFromCache(withUrl imageUrl: String?, indexPath: IndexPath) -> UIImage? {
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
                NSLog("Error getting image fom cache")
            }
        }
        return nil
    }

    
    func loadImagesForOnscreenCells(_ indexPathsForVisibleItems: [IndexPath]) {
        guard let allPendingOperations = worker?.getPendingOperations() else {
            print("No Pending operations")
            return
        }
        let toBeCancelled = allPendingOperations
        let visiblePaths = Set(indexPathsForVisibleItems as [NSIndexPath])
        let _ = toBeCancelled.subtracting(visiblePaths)

        // loadImagesForOnscreenCells
        let toBeStarted = visiblePaths
        let _ = toBeStarted.subtracting(allPendingOperations)
        
        //
        worker?.removeOperationsInProgess(cancelledIndexPaths: toBeCancelled)

        //
        for indexPath in toBeStarted {
            let indexPathObject = indexPath as NSIndexPath
            let imageDetails = self.searchResultsArray![indexPathObject.row]
                worker?.startOperationsForImage(imageUrl: imageDetails.previewURL, indexPath: indexPath, {
                    [weak self, weak imageDetails, indexPath] (isDownloadComplete) in
                    print("Preview ImageDownload Complete for index \(indexPath.item)")
                    if isDownloadComplete {
                        imageDetails?.imageState = .Downloaded
                        self?.presenter?.reloadItems(at: [indexPath as IndexPath])
                    }
            })
        }
        
    }
    
    func suspendAllOperations () {
        worker?.suspendAllOperations()
    }

    func resumeAllOperations () {
        worker?.resumeAllOperations()
    }
    
    func setSelectedIndex(_ index: Int) {
        selectedIndex = index
    }
}
