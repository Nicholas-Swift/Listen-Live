//
//  ContainerViewController.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/25/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    // MARK: - Instance Vars
    var radioTopConstraint: NSLayoutConstraint!
    let radioNotShown: CGFloat = 0
    let radioPartiallyShown: CGFloat = -80
    var radioFullyShown: CGFloat!
    
    // MARK: - Subviews
    let searchViewController = SearchViewController()
    let radioViewController = RadioViewController()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup different possible states
        radioFullyShown = -view.bounds.height
        
        setupSearchViewController()
        setupRadioViewController()
        setupConstraints()
    }
    
}

// MARK: - Search View Controller
extension ContainerViewController {

    func setupSearchViewController() {
        searchViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchViewController.view)
    }
}

// MARK: - Radio View Controller
extension ContainerViewController {
    
    func setupRadioViewController() {
        radioViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(radioViewController.view)
    }
}

// MARK: - Auto Layout
extension ContainerViewController {
    
    func setupConstraints() {
        
        // Search View Controller
        let searchTop = NSLayoutConstraint(item: searchViewController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let searchBottom = NSLayoutConstraint(item: searchViewController.view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let searchLeft = NSLayoutConstraint(item: searchViewController.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let searchRight = NSLayoutConstraint(item: searchViewController.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([searchTop, searchBottom, searchLeft, searchRight])
        
        // Radio View Controller
        radioTopConstraint = NSLayoutConstraint(item: radioViewController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: radioPartiallyShown)
        let radioLeft = NSLayoutConstraint(item: radioViewController.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let radioRight = NSLayoutConstraint(item: radioViewController.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let radioHeight = NSLayoutConstraint(item: radioViewController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.bounds.height)
        NSLayoutConstraint.activate([radioTopConstraint, radioLeft, radioRight, radioHeight])
        print(radioViewController.view.constraints)
    }
    
}
