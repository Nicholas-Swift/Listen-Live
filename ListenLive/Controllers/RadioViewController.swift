//
//  RadioViewController.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import AVFoundation

protocol RadioViewControllerDelegate {
    func tableViewPulledFromTopWith(offset: CGFloat)
    func tableViewStoppedPulling()
    func radioViewControllerShouldMinimize()
}

class RadioViewController: UIViewController {
    
    // MARK: - Instance Vars
    let viewModel = RadioViewModel()
    var delegate: RadioViewControllerDelegate?
    
    // MARK: - Subviews
    lazy var tableView: UITableView = {
        let view = UITableView.newAutoLayoutView()
        return view
    }()
    var radioControlTableViewCell: RadioControlsTableViewCell!
    lazy var smallPlayer = SmallPlayerView.instanceFromNib()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Radio Controls Table View Cell - WTF?
        radioControlTableViewCell = RadioControlsTableViewCell.instanceFromNib() as! RadioControlsTableViewCell
        viewModel.setupRadioControlsTableViewCell(cell: radioControlTableViewCell)
        radioControlTableViewCell.delegate = self
        
        setupSmallPlayer()
        setupTableView()
        setupConstraints()
    }
    
}

// MARK: - Small Player
extension RadioViewController {
    
    func setupSmallPlayer() {
        
        // Add Subview
        view.addSubview(smallPlayer)
    }
    
}

// MARK: - Scroll View
extension RadioViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Calculate y
        if scrollView.contentOffset.y < 0 {
            
            // Pull down
            delegate?.tableViewPulledFromTopWith(offset: scrollView.contentOffset.y)
            tableView.contentOffset = CGPoint.zero
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Velocity very fast
        if tableView.contentOffset == CGPoint.zero {
            let scrollVelocity = scrollView.panGestureRecognizer.velocity(in: self.view)
            if(scrollVelocity.y) > 1000 {
                delegate?.radioViewControllerShouldMinimize()
                return
            }
        }
        
        // Normal pull
        if scrollView.contentOffset.y <= 0 {
            delegate?.tableViewStoppedPulling()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            delegate?.tableViewStoppedPulling()
        }
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
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        
        // Add subview
        view.addSubview(tableView)
    }
    
}

// MARK: - Table View Delegate
extension RadioViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(indexPath: indexPath)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioNavigationTableViewCell", for: indexPath) as! RadioNavigationTableViewCell
            cell.delegate = self
            viewModel.setupRadioNavigationTableViewCell(cell: cell)
            return cell
            
        // Radio Controls Table View Cell
        case 1:
            return radioControlTableViewCell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioControlsTableViewCell", for: indexPath)
//            viewModel.setupRadioControlsTableViewCell(cell: cell)
//            return cell
            
        // Track Table View Cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioTrackTableViewCell", for: indexPath)
            viewModel.setupRadioTrackTableViewCell(cell: cell, indexPath: indexPath)
            return cell
        }
    }
    
}

// MARK: - Table View Cell Delegates
extension RadioViewController: RadioNavigationTableViewCellDelegate, RadioControlsTableViewCellDelegate {
    
    // MARK: - Navigation
    func downButtonPressed() {
        delegate?.radioViewControllerShouldMinimize()
    }
    
    func optionsButtonPressed() {
        print("OPTIONS BUTTON PRESSED")
    }
    
    // MARK: - Controls
    func sliderDurationChanged(duration: Float) {
        print("DURATION CHANGED \(duration)")
    }
    
    func rewindButtonPressed() {
        print("REWIND")
    }
    
    func playButtonPressed() {
        
        if(Player.player.rate != 0 && Player.player.error == nil) {
            Player.player.pause()
        } else {
            Player.player.play()
        }
    }
    
    func fastForwardButtonPressed() {
        print("FAST FORWARD")
    }
    
}

// MARK: - Auto Layout
extension RadioViewController {
    
    func setupConstraints() {
        
        // Small Player
        let smallTop = NSLayoutConstraint(item: smallPlayer, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let smallLeft = NSLayoutConstraint(item: smallPlayer, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let smallRight = NSLayoutConstraint(item: smallPlayer, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let smallHeight = NSLayoutConstraint(item: smallPlayer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70)
        NSLayoutConstraint.activate([smallTop, smallLeft, smallRight, smallHeight])
        
        // Table View
        let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: smallPlayer, attribute: .bottom, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([top, bottom, left, right])
    }
    
}


