//
//  ExploreImagesViewController.swift
//  ExplorImg
//
//  Created by Ankit Batra on 25/10/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ExploreImagesDisplayLogic: AnyObject {
    func reloadCollectionView()
    func reloadItems(at indexPaths:[IndexPath])
    func showError()
}

class ExploreImagesViewController: UIViewController, ExploreImagesDisplayLogic, UISearchControllerDelegate {
    
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    private var suggestionsTableViewController: SuggestionsTableViewController!

    var searchController : UISearchController!
    var interactor: ExploreImagesBusinessLogic?
    var router: (NSObjectProtocol & ExploreImagesRoutingLogic & ExploreImagesDataPassing)?
    
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
        let interactor = ExploreImagesInteractor()
        let presenter = ExploreImagesPresenter()
        let router = ExploreImagesRouter()
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
        setupSearchController()
    }
    
    // MARK: View Logic
    func setupSearchController()
    {
        suggestionsTableViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "SuggestionsTableViewController") as? SuggestionsTableViewController
        suggestionsTableViewController.tableView.delegate = self
        searchController = UISearchController(searchResultsController: suggestionsTableViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = true
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            if self?.router?.dataStore?.pagenumber == 1 && self?.router?.dataStore?.searchResultsArray?.count ?? 0 > 0 {
                self?.searchResultsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
            self?.searchResultsCollectionView.reloadData()
        }
    }
    
    func reloadItems(at indexPaths:[IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            self?.searchResultsCollectionView.reloadItems(at: indexPaths)
        }
    }
    
    func showError() {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: "ExplorImg", message: "Sorry! Couldnot find any (more) images for the keyword(s). Please try with another keyword.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}


extension ExploreImagesViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        NSLog("searchBar textDidChange \(searchText)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {
            return
        }
        NSLog("SearchBar search button clicked  \(searchBarText)")
        searchBar.resignFirstResponder()
        interactor?.getDataFromPixabay(forSearchText: searchBarText)
        self.searchController.isActive = false
        self.searchController.isEditing = false
        self.searchController.searchBar.text = searchBarText
    }
}



extension ExploreImagesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let suggestion = suggestionsTableViewController.suggestions.reversed()[indexPath.row]
        searchController.searchBar.resignFirstResponder()
        interactor?.getDataFromPixabay(forSearchText: suggestion)
        searchController.isActive = false
        searchController.isEditing = false
        searchController.searchBar.text = suggestion
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
