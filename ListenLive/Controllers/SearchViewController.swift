//
//  SearchViewController.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Instance Vars
    let viewModel = SearchViewModel()
    
    // MARK: - Subviews
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupTableView()
        setupConstraints()
    }
}

// MARK: - Collection View
extension SearchViewController {
    
    func setupCollectionView() {
        
        // Delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register cells
        collectionView.register(SearchListenerCollectionViewCell.nib(), forCellWithReuseIdentifier: "SearchListenerCollectionViewCell")
        
        // Style
        collectionView.backgroundColor = UIColor.clear
        collectionView.alwaysBounceVertical = false
        collectionView.showsHorizontalScrollIndicator = false
        
        // Add subview
        view.addSubview(collectionView)
    }
    
}

// MARK: - Collection View Delegate
extension SearchViewController: UICollectionViewDelegate {
    
}

// MARK: - Collection View Data Source
extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchListenerCollectionViewCell", for: indexPath) as! SearchListenerCollectionViewCell
        return cell
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
        
        // Style
//        tableView.separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderIn(section: section)
    }
    
}

// MARK: - Table View Datasource
extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioTrackTableViewCell")!
        return cell
    }
    
}

// MARK: - Auto Layout
extension SearchViewController {
    
    func setupConstraints() {
        
        // Collection View
        let collectionViewTop = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20)
        let collectionViewLeft = NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let collectionViewRight = NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let collectionViewHeight = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 88)
        NSLayoutConstraint.activate([collectionViewTop, collectionViewLeft, collectionViewRight, collectionViewHeight])
        
        // Table View
        let tableViewTop = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1, constant: 0)
        let tableViewBottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let tableViewLeft = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let tableViewRight = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([tableViewTop, tableViewBottom, tableViewLeft, tableViewRight])
    }
    
}
