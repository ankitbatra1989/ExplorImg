//
//  ExploreImagesDetailViewController.swift
//  ExplorImg
//
//  Created by Ankit Batra on 28/10/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ExploreImagesDetailDisplayLogic: AnyObject {
    func reloadItems(at indexPaths:[IndexPath])
    func scrollToItem(indexPath: IndexPath)
}

class ExploreImagesDetailViewController: UIViewController, ExploreImagesDetailDisplayLogic {
    var interactor: ExploreImagesDetailBusinessLogic?
    var router: (NSObjectProtocol & ExploreImagesDetailRoutingLogic & ExploreImagesDetailDataPassing)?
    
    @IBOutlet weak var imageDetailCollectionView: UICollectionView!

    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ExploreImagesDetailInteractor()
        let presenter = ExploreImagesDetailPresenter()
        let router = ExploreImagesDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDetailCollectionView.performBatchUpdates(nil) { [weak self] (isCompleted) in
            if isCompleted {
                self?.interactor?.scrollToSelectedItem()
            }
        }
    }
    
    // MARK: View Logic
    func reloadItems(at indexPaths:[IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            self?.imageDetailCollectionView.reloadItems(at: indexPaths)
        }
    }
    
    func scrollToItem(indexPath: IndexPath) {
        imageDetailCollectionView.scrollToItem(at: indexPath, at: .right, animated: false)
    }
}


extension ExploreImagesDetailViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return router?.dataStore?.searchResultsArray?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height:collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "ImageDetailCollectionViewCell"
        let cell: ImageDetailCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ImageDetailCollectionViewCell)!
        
        let imageAtIndex = router?.dataStore?.searchResultsArray![indexPath.row]
        cell.detailImageView.image = UIImage(named: "placeholder.png")
        if imageAtIndex?.largeImageState == .Downloaded {
            let image = interactor?.getImageFromCache(withUrl: imageAtIndex?.largeImageURL, indexPath: indexPath)
            DispatchQueue.main.async {
                cell.detailImageView.image = image
            }
        } else if (imageAtIndex?.imageState == .Downloaded) {
            let image = interactor?.getImageFromCache(withUrl: imageAtIndex?.previewURL, indexPath: indexPath)
            DispatchQueue.main.async {
                cell.detailImageView.image = image
            }
            interactor?.getImage(for: imageAtIndex, indexPath: indexPath)
        } else {
            interactor?.getImage(for: imageAtIndex, indexPath: indexPath)
        }
        return cell
    }

}
