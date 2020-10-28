//
//  ExploreImagesPresenter.swift
//  ExplorImg
//
//  Created by Ankit Batra on 25/10/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
    
protocol ExploreImagesPresentationLogic: AnyObject {
    func reloadCollectionView()
    func reloadItems(at indexPaths:[IndexPath])
    func showError()
    
}

class ExploreImagesPresenter: ExploreImagesPresentationLogic {
    weak var viewController: ExploreImagesDisplayLogic?
    
    // MARK: Presentation Logic
    
    func reloadCollectionView() {
        viewController?.reloadCollectionView()
    }
    
    func reloadItems(at indexPaths:[IndexPath]) {
        viewController?.reloadItems(at: indexPaths)
    }
    
    func showError() {
        viewController?.showError()
    }
}
