//
//  ContainerViewController.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/25/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

enum RadioShown {
    case notShown
    case partiallyShown
    case fullyShown
}

class ContainerViewController: UIViewController {
    
    // MARK: - Instance Vars
    var radioTopConstraint: NSLayoutConstraint!
    var radioShown: RadioShown = .partiallyShown
    var radioShownDict: [RadioShown: CGFloat]!
    var beginOffset: CGFloat!
    var currentOffset: CGFloat!
    var tableViewOffset: CGFloat = 0
    
    // MARK: - Subviews
    let searchViewController = SearchViewController()
    let radioViewController = RadioViewController()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup different possible states
        radioShownDict = [.notShown: 0, .partiallyShown: -80, .fullyShown: -view.bounds.height - 80]
        
        // Setup Subviews
        setupPanGestureRecognizer()
        setupSearchViewController()
        setupRadioViewController()
        setupConstraints()
    }
    
    
    
}

// MARK: - Status Bar
extension ContainerViewController {
    override var prefersStatusBarHidden: Bool {
        return radioShown == .fullyShown ? true : false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}

// MARK: - Pan Gesture Recognizer
extension ContainerViewController {
    
    func setupPanGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPanOnView(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        view.addGestureRecognizer(pan)
    }
    
    func didPanOnView(_ sender: UIPanGestureRecognizer) {
        let yLocation = sender.location(in: view).y
        
        if sender.state == .began {
            // Began pan gesture
            beginOffset = yLocation
        } else if sender.state == .changed {
            // Changed pan gesture
            panGestureChanged(at: yLocation)
        } else if sender.state == .ended {
            // Ended pan gesture
            let yVelocity = sender.velocity(in: view).y
            panGestureEnded(with: yVelocity)
        }
    }
    
    func panGestureChanged(at yLocation: CGFloat) {
        
        // Calculate offset
        currentOffset = yLocation - beginOffset
        switch(radioShown) {
        case .notShown:
            break
        case .partiallyShown:
            currentOffset = currentOffset - CGFloat(80)
        case .fullyShown:
            currentOffset = currentOffset - view.bounds.height + radioShownDict[.partiallyShown]!
        }
        
        // Not over max
        if currentOffset > radioShownDict[.partiallyShown]! {
            currentOffset = radioShownDict[.partiallyShown]!
        }
        else if currentOffset < -view.bounds.height + radioShownDict[.partiallyShown]! {
            currentOffset = -view.bounds.height + radioShownDict[.partiallyShown]!
        }
        
        // Set constraints
        radioTopConstraint.constant = currentOffset
    }
    
    func panGestureEnded(with yVelocity: CGFloat) {
        
        // Quick swipe with velocity
        if abs(yVelocity) > 500 {
            if yVelocity > 0 {
                radioTopConstraint.constant = radioShownDict[.partiallyShown]!
                radioShown = .partiallyShown
            } else {
                radioTopConstraint.constant = radioShownDict[.fullyShown]!
                radioShown = .fullyShown
            }
        }
        
        // Slow swipe
        else {
            if currentOffset > -view.bounds.height/2 {
                radioTopConstraint.constant = radioShownDict[.partiallyShown]!
                radioShown = .partiallyShown
            } else {
                radioTopConstraint.constant = radioShownDict[.fullyShown]!
                radioShown = .fullyShown
            }
        }
        
        // Animate
        UIView.animate(withDuration: 0.3, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
        })
        
        // Reset offsets
        beginOffset = 0
        currentOffset = 0
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
extension ContainerViewController: RadioViewControllerDelegate {
    
    func setupRadioViewController() {
        radioViewController.delegate = self
        radioViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(radioViewController.view)
    }
    
    func tableViewPulledFromTopWith(offset: CGFloat) {
        beginOffset = 0
        tableViewOffset -= offset
        panGestureChanged(at: tableViewOffset)
    }
    
    func tableViewStoppedPulling() {
        beginOffset = 0
        tableViewOffset = 0
        panGestureEnded(with: 0)
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
        radioTopConstraint = NSLayoutConstraint(item: radioViewController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -80)
        let radioLeft = NSLayoutConstraint(item: radioViewController.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let radioRight = NSLayoutConstraint(item: radioViewController.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let radioHeight = NSLayoutConstraint(item: radioViewController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.bounds.height + 80)
        NSLayoutConstraint.activate([radioTopConstraint, radioLeft, radioRight, radioHeight])
    }
    
}
