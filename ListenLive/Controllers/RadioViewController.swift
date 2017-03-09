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
    func radioViewControllerShouldMaximize()
    func shouldShowAlertController(alert: UIAlertController)
}

class RadioViewController: UIViewController {
    
    // MARK: - Instance Vars
    let viewModel = RadioViewModel()
    var delegate: RadioViewControllerDelegate?
    var isPullingDown: Bool = false
    var inPullTransition: Bool = false
    
    // MARK: - Subviews
    lazy var tableView: UITableView = {
        let view = UITableView.newAutoLayoutView()
        return view
    }()
    var radioNavigationTableViewCell: RadioNavigationTableViewCell!
    var radioControlTableViewCell: RadioControlsTableViewCell!
    lazy var smallPlayer = SmallPlayerView.instanceFromNib() as! SmallPlayerView
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        setupSmallPlayer()
        setupTableView()
        setupConstraints()
    }
    
}

// MARK: - Notifications
extension RadioViewController {
    
    func setupNotifications() {
    
        // Current Track Changed
        NotificationCenter.default.addObserver(self, selector: #selector(currentTrackChangedNotification(notification:)), name: PlayerNotifications.currentTrackChanged, object: nil)
        
        // Current Queue Changed
        NotificationCenter.default.addObserver(self, selector: #selector(currentQueueChangedNotification(notification:)), name: PlayerNotifications.currentQueueChanged, object: nil)
        
    }
    
    // Current Track Changed
    func currentTrackChangedNotification(notification: Notification) {
        
        // Make sure it's a track
        guard let track = notification.object as? Track else {
            return
        }
        
        // Change small player
        smallPlayer.trackTitleLabel.text = track.title
        smallPlayer.trackSubtitleLabel.text = track.songId
        smallPlayer.thumbnailImageView.af_setImage(withURL: track.thumbnailURL)
        
        // Change control table view cell
        radioControlTableViewCell.trackTitleLabel.text = track.title
        radioControlTableViewCell.trackSubtitleLabel.text = track.songId
    }
    
    // Current Queue Changed
    func currentQueueChangedNotification(notification: Notification) {
        
        // Make sure it's a track queue
        guard let trackQueue = notification.object as? [Track] else {
            return
        }
        
        // Set queue
        viewModel.tracks = trackQueue
        
        // Reload table view
        tableView.reloadData()
    }
    
}

// MARK: - Small Player
extension RadioViewController: SmallPlayerViewDelegate {
    
    func setupSmallPlayer() {
        
        smallPlayer.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(smallPlayerTapped))
        smallPlayer.addGestureRecognizer(tap)
        
        // Add Subview
        view.addSubview(smallPlayer)
    }
    
    func smallPlayerTapped() {
        delegate?.radioViewControllerShouldMaximize()
    }
    
    func smallPlayerReset() {
        smallPlayer.trackTitleLabel.text = "Add a song..."
        smallPlayer.trackSubtitleLabel.text = ""
        smallPlayer.thumbnailImageView.image = nil
    }
    
}

// MARK: - Scroll View
extension RadioViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Calculate y
        if scrollView.contentOffset.y < 0 {
            
            // Pulling down
            if inPullTransition {
                isPullingDown = true
            }
            
            // Pull down
            delegate?.tableViewPulledFromTopWith(offset: scrollView.contentOffset.y)
            tableView.contentOffset = CGPoint.zero
        }
        
        // Pushing back up
        else if isPullingDown && inPullTransition {
            
            // Push up
            delegate?.tableViewPulledFromTopWith(offset: scrollView.contentOffset.y)
            tableView.contentOffset = CGPoint.zero
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // Start in transition
        self.inPullTransition = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Stop in transition
        self.isPullingDown = false
        self.inPullTransition = false
        
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
        
        // Radio Navigation Table View Cell
        radioNavigationTableViewCell = RadioNavigationTableViewCell.instanceFromNib() as! RadioNavigationTableViewCell
        viewModel.setupRadioNavigationTableViewCell(cell: radioNavigationTableViewCell)
        radioNavigationTableViewCell.delegate = self
        
        // Radio Controls Table View Cell
        radioControlTableViewCell = RadioControlsTableViewCell.instanceFromNib() as! RadioControlsTableViewCell
        viewModel.setupRadioControlsTableViewCell(cell: radioControlTableViewCell)
        radioControlTableViewCell.delegate = self
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
            return radioNavigationTableViewCell
            
        // Radio Controls Table View Cell
        case 1:
            return radioControlTableViewCell
            
        // Track Table View Cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioTrackTableViewCell", for: indexPath) as! RadioTrackTableViewCell
            viewModel.setupRadioTrackTableViewCell(cell: cell, indexPath: indexPath)
            cell.delegate = self
            return cell
        }
    }
    
}

// MARK: - Table View Cell Delegates
extension RadioViewController: RadioNavigationTableViewCellDelegate {
    
    func downButtonPressed() {
        delegate?.radioViewControllerShouldMinimize()
    }
    
    func optionsButtonPressed() {
        
        // Create alert
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // Save Song action
        let saveAction = UIAlertAction(title: "Save Current Song", style: .default) { (alert: UIAlertAction) in
            if let currentTrack = GlobalPlayer.currentTrack {
                self.viewModel.saveTrack(track: currentTrack)
            }
        }
        alert.addAction(saveAction)
        
        // Leave action
        let leaveAction = UIAlertAction(title: "Leave Radio", style: .destructive) { (alert: UIAlertAction) in
            GlobalPlayer.currentQueue = []
            GlobalPlayer.currentTrack = nil
        }
        alert.addAction(leaveAction)
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        delegate?.shouldShowAlertController(alert: alert)
    }
    
}

extension RadioViewController: RadioControlsTableViewCellDelegate {
    
    func sliderDurationChanged(duration: Float) {
        print("DURATION CHANGED \(duration)")
    }
    
    // Disable Rewind for now
    func rewindButtonPressed() {
        print("REWIND")
    }
    
    // Play or pause
    func playButtonPressed() {
        if(Player.player.rate != 0 && Player.player.error == nil) {
            Player.player.pause()
            smallPlayer.playButton.setImage(#imageLiteral(resourceName: "ic_play"), for: .normal)
            radioControlTableViewCell.playButton.setImage(#imageLiteral(resourceName: "ic_play_large"), for: .normal)
        } else {
            Player.player.play()
            smallPlayer.playButton.setImage(#imageLiteral(resourceName: "ic_pause"), for: .normal)
            radioControlTableViewCell.playButton.setImage(#imageLiteral(resourceName: "ic_pause_large"), for: .normal)
        }
    }
    
    // Skip to next song
    func fastForwardButtonPressed() {
        Player.player.skip()
        if GlobalPlayer.currentTrack == nil {
            
            // Update radio view controller front end
            smallPlayerReset()
            radioControlTableViewCell.removeCurrentSong()
            radioControlTableViewCell.trackTitleLabel.text = "Add a track"
            radioControlTableViewCell.trackSubtitleLabel.text = "..."
            
            // Update play pause button
            smallPlayer.playButton.setImage(#imageLiteral(resourceName: "ic_pause"), for: .normal)
            radioControlTableViewCell.playButton.setImage(#imageLiteral(resourceName: "ic_pause_large"), for: .normal)
        }
    }
    
}

extension RadioViewController: RadioTrackTableViewCellDelegate {
    func moreButtonPressed(sender: RadioTrackTableViewCell) {
        
        // Get index path
        guard var indexPath = tableView.indexPath(for: sender) else {
            return
        }
        indexPath.row -= 2
        
        // Get track
        let track: Track = viewModel.getTrack(at: indexPath)
        
        // Create alert
        let alert = UIAlertController(title: track.title, message: nil, preferredStyle: .actionSheet)

        // Save action
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alert) in
            self.viewModel.saveTrack(track: track)
        }
        alert.addAction(saveAction)
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        delegate?.shouldShowAlertController(alert: alert)
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


