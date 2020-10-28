//
//  ExploreImagesViewController+UICollectionViewDelegate.swift
//  ExplorImg
//
//  Created by Ankit Batra on 25/10/20.
//

import Foundation
import UIKit

extension ExploreImagesViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return router?.dataStore?.searchResultsArray?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.bounds.size.width - 30)/2, height:(self.view.bounds.size.width - 30)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "searchResultsCollectionViewCell"
        let cell: SearchResultsCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? SearchResultsCollectionViewCell)!
        
        let imageAtIndex = router?.dataStore?.searchResultsArray![indexPath.row]
        cell.searchResultImageView.image = UIImage(named: "placeholder.png")
        switch (imageAtIndex?.imageState) {
        case .New:
            if (!collectionView.isDragging && !collectionView.isDecelerating) {
                interactor?.getImage(for: imageAtIndex, indexPath: indexPath)
            }
        case .Downloaded:
            let image = interactor?.getImageFromCache(withUrl: imageAtIndex?.previewURL, indexPath: indexPath)
            DispatchQueue.main.async {
                cell.searchResultImageView.image = image
            }
        default:
            NSLog("do nothing")
        }
           
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  0.0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
        collectionView.deselectItem(at: indexPath, animated: true)
        interactor?.setSelectedIndex(indexPath.item)
        performSegue(withIdentifier: "ExploreImagesDetail", sender: nil)

    }
}

extension ExploreImagesViewController: UIScrollViewDelegate {
    //MARK : ScrollView Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight: Int = Int(contentHeight - contentOffset)
        let frameHeight : Int = Int(scrollView.bounds.size.height)
        if(diffHeight <= frameHeight && router?.dataStore?.isLoadingNewData == false)
        {
            interactor?.getDataFromPixabay(forSearchText: nil)
        }
    }
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        interactor?.suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            interactor?.loadImagesForOnscreenCells(searchResultsCollectionView.indexPathsForVisibleItems)
            interactor?.resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        interactor?.loadImagesForOnscreenCells(searchResultsCollectionView.indexPathsForVisibleItems)
        interactor?.resumeAllOperations()
    }

}
