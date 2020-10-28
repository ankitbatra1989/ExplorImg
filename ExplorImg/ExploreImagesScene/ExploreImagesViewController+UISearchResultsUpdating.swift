//
//  ExploreImagesViewController+UISearchResultsUpdating.swift
//  ExplorImg
//
//  Created by Ankit Batra on 28/10/20.
//

import Foundation
import UIKit

extension ExploreImagesViewController: UISearchResultsUpdating {

   func updateSearchResults(for searchController: UISearchController) {
       // Update the filtered array based on the search text.
        let searchResults = router?.dataStore?.successfullySearchedStrings

       // Apply the filtered results to the search results table.
       if let suggestionTableViewController = searchController.searchResultsController as? SuggestionsTableViewController {
        suggestionTableViewController.suggestions = searchResults ?? []
        suggestionTableViewController.tableView.reloadData()
       }
   }
   
}

