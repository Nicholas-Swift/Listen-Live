//
//  SearchViewController.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class SearchViewController: UIViewController {
    
    // MARK: - Instance Vars
    let viewModel = SearchViewModel()
    
    // MARK: - Subviews
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    var searchController: UISearchController!
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get tracks
        viewModel.getRecentTracks() { [weak self] in self?.tableView.reloadData() }
        viewModel.getPopularTracks() { [weak self] in self?.tableView.reloadData() }
        viewModel.getSavedTracks() { [weak self] in self?.tableView.reloadData() }
        
        // Set up other subviews
        setupSearchController()
        setupTableView()
        setupConstraints()
    }
}

// MARK: - Search Controller
extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController:  nil)
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        
        // Change nav bar background
        navBar.isTranslucent = false
        navBar.setBackgroundImage(UIImage.withColor(color: UIColor.white), for: .default)
        
        // Change searchBar background color
        for view in self.searchController.searchBar.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UITextField.self) {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
                }
            }
        }
        
        navItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        viewModel.isSearching = true
        viewModel.searchedTracks = []
        tableView.reloadData()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.isSearching = false
        viewModel.searchedTracks = []
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
        perform(#selector(search), with: nil, afterDelay: 0.2)
    }
    
    func search() {
        
        // Get the search term
        guard let searchTerm = searchController.searchBar.text else {
            return
        }
        
        // Return if nothing
        if searchTerm == "" {
            return
        }
        
        // Get searched tracks
        viewModel.getSearchedTracks(searchTerm: searchTerm) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
}

// MARK: - Search Scrolling
extension SearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(viewModel.isSearching) {
            searchController.searchBar.resignFirstResponder()
            if searchController.searchBar.text == "" {
                tableView.reloadData()
            }
        }
    }
    
}


// MARK: - Table View
extension SearchViewController {
    
    func setupTableView() {
        
        // Delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Cell size
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Register cells
        tableView.register(RadioTrackTableViewCell.nib(), forCellReuseIdentifier: "RadioTrackTableViewCell")
        
        // Add subview
        view.addSubview(tableView)
    }
    
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForHeaderIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.heightForFooterIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SearchHeaderView.instanceFromNib() as! SearchHeaderView
        headerView.translatesAutoresizingMaskIntoConstraints = true
        headerView.titleHeaderLabel.text = viewModel.titleForHeaderIn(section: section)
        return headerView
    }
    
}

// MARK: - Table View Datasource
extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Track table view cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioTrackTableViewCell") as! RadioTrackTableViewCell
        viewModel.setupRadioTrackTableViewCell(cell: cell, at: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.playTrack(at: indexPath)
    }
    
}

// MARK: - Table View Cell Delegate
extension SearchViewController: RadioTrackTableViewCellDelegate {
    
    func moreButtonPressed(sender: RadioTrackTableViewCell) {
        
        // Get index path
        guard let indexPath = tableView.indexPath(for: sender) else {
            return
        }
        
        // Get track
        let track: Track = viewModel.getTrack(at: indexPath)
        
        // Create alert
        let alert = UIAlertController(title: track.title, message: nil, preferredStyle: .actionSheet)
        
        // Save action
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alert) in
            self.viewModel.saveTrack(track: track)
        }
        alert.addAction(saveAction)
        
        // Remove action
        if viewModel.sections[indexPath.section] == "Saved" {
            let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alert) in
                self.viewModel.removeTrack(track: track)
            }
            alert.addAction(removeAction)
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // Present alert
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Auto Layout
extension SearchViewController {
    
    func setupConstraints() {
        
        // Table View
        let tableViewTop = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 64)
        let tableViewBottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let tableViewLeft = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let tableViewRight = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([tableViewTop, tableViewBottom, tableViewLeft, tableViewRight])
    }
    
}
