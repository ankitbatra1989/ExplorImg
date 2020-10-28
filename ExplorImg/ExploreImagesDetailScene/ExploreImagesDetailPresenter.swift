//
//  ExploreImagesDetailPresenter.swift
//  ExplorImg
//
//  Created by Ankit Batra on 28/10/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ExploreImagesDetailPresentationLogic: AnyObject {
    func reloadItems(at indexPaths:[IndexPath])
    func scrollToItem(indexPath: IndexPath)
}

class ExploreImagesDetailPresenter: ExploreImagesDetailPresentationLogic {
    weak var viewController: ExploreImagesDetailDisplayLogic?
    
    // MARK: Presentation Logic
 
    func reloadItems(at indexPaths:[IndexPath]) {
        viewController?.reloadItems(at: indexPaths)
    }
    
    func scrollToItem(indexPath: IndexPath) {
        viewController?.scrollToItem(indexPath: indexPath)
    }
}
