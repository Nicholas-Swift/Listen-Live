//
//  RadioViewController.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class RadioViewController: UIViewController {
    
    // MARK: - Instance Vars
    let viewModel = RadioViewModel()
    
    // MARK: - Subviews
    lazy var tableView: UITableView = {
        let view = UITableView.newAutoLayoutView()
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
extension RadioViewController {
    
    func setupTableView() {
        
        // Delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Cell size
        tableView.estimatedRowHeight = 100
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
extension RadioViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row) {
            
        // Radio Navigation Table View Cell
        case 0:
            return viewModel.heightForRadioNavigationTableViewCell()
            
        // Radio Controls Table View Cell
        case 1:
            return viewModel.heightForRadioControlsTableViewCell()
            
        // Track Table View Cell
        default:
            return viewModel.heightForRadioTrackTableViewCell()
        }
    }
    
}

// MARK: - Table View Datasource
extension RadioViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.row) {
            
        // Radio Navigation Table View Cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioNavigationTableViewCell", for: indexPath)
            viewModel.setupRadioNavigationTableViewCell(cell: cell)
            return cell
            
        // Radio Controls Table View Cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioControlsTableViewCell", for: indexPath)
            viewModel.setupRadioControlsTableViewCell(cell: cell)
            return cell
            
        // Track Table View Cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioTrackTableViewCell", for: indexPath)
            viewModel.setupRadioTrackTableViewCell(cell: cell, indexPath: indexPath)
            return cell
        }
    }
    
}

// MARK: - Auto Layout
extension RadioViewController {
    
    func setupConstraints() {
        
        // Table View
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)])
    }
    
}


