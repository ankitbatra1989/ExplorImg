//
//  ExploreImagesRouter.swift
//  ExplorImg
//
//  Created by Ankit Batra on 25/10/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol ExploreImagesRoutingLogic: AnyObject {
    func routeToExploreImagesDetail(segue: UIStoryboardSegue?)
}

protocol ExploreImagesDataPassing {
    var dataStore: ExploreImagesDataStore? { get }
}

class ExploreImagesRouter: NSObject, ExploreImagesRoutingLogic, ExploreImagesDataPassing {
    weak var viewController: ExploreImagesViewController?
    var dataStore: ExploreImagesDataStore?
    
    // MARK: Routing
    
    func routeToExploreImagesDetail(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! ExploreImagesDetailViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToExploreImagesDetail(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ExploreImagesDetailViewController") as! ExploreImagesDetailViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToExploreImagesDetail(source: dataStore!, destination: &destinationDS)
            navigateToExploreImagesDetail(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToExploreImagesDetail(source: ExploreImagesViewController, destination: ExploreImagesDetailViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToExploreImagesDetail(source: ExploreImagesDataStore, destination: inout ExploreImagesDetailDataStore) {
        destination.searchResultsArray = source.searchResultsArray
        destination.pagenumber = source.pagenumber
        destination.selectedIndex = source.selectedIndex
    }
}
