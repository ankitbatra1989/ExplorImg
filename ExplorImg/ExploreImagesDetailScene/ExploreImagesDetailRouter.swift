//
//  ExploreImagesDetailRouter.swift
//  ExplorImg
//
//  Created by Ankit Batra on 28/10/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol ExploreImagesDetailRoutingLogic: AnyObject {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ExploreImagesDetailDataPassing {
    var dataStore: ExploreImagesDetailDataStore? { get }
}

class ExploreImagesDetailRouter: NSObject, ExploreImagesDetailRoutingLogic, ExploreImagesDetailDataPassing {
    weak var viewController: ExploreImagesDetailViewController?
    var dataStore: ExploreImagesDetailDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?) {
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: ExploreImagesDetailViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: ExploreImagesDetailDataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}
