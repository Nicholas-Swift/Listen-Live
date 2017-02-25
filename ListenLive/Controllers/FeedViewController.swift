//
//  FeedViewController.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Instance Vars
    let viewModel = FeedViewModel()
    
    // MARK: - Subviews
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .grouped)
        return view
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupConstraints()
    }
    
}

// MARK: - Table View
extension FeedViewController {
    
    func setupTableView() {
        
        // Delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Cell size
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Register cells
        tableView.register(RadioNavigationTableViewCell.nib(), forCellReuseIdentifier: "RadioNavigationTableViewCell")
        tableView.register(RadioControlsTableViewCell.nib(), forCellReuseIdentifier: "RadioControlsTableViewCell")
        tableView.register(RadioTrackTableViewCell.nib(), forCellReuseIdentifier: "RadioTrackTableViewCell")
        
        // Style
        tableView.separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        
        // Add subview
        view.addSubview(tableView)
    }
    
}

// MARK: - Table View Delegate
extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
}

// MARK: - Table View Datasource
extension FeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

// MARK: - Auto Layout
extension FeedViewController {
    
    func setupConstraints() {
        
        // Table View
        let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20)
        let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([top, bottom, left, right])
    }
    
}
