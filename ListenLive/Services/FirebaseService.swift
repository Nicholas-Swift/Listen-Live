//
//  FirebaseService.swift
//  ListenLive
//
//  Created by Brian Hans on 2/25/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

class FirebaseService {
    
    static let ref = FIRDatabase.database().reference()
    
    static func listenToFriends(startedListening: () -> Void) {
        
    }
    
    static func getSavedTracks(completionHandler: @escaping ([Track], Error?) -> Void) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            completionHandler([], nil)
            return
        }
        
        ref.child(FirebaseConstants.tracks).child(currentUser.uid).observe(.value, with: { (snapshot) in
            
            var tracks: [Track] = []
            for item in snapshot.children {
                if let child = item as? FIRDataSnapshot, let json = child.value as? [String:Any] {
                    if let track = Track(snapshot: json) {
                        tracks.append(track)
                    }
                }
            }
            
            completionHandler(tracks, nil)
        })
    }
    
    static func saveTrack(track: Track) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        
        ref.child(FirebaseConstants.tracks).child(currentUser.uid).child(track.songId).setValue(track.toJSON())
    }
    
    static func removeTrack(track: Track) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        
        ref.child(FirebaseConstants.tracks).child(currentUser.uid).child(track.songId).removeValue()
    }
    
    static func addToHistory(track: Track) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        
        ref.child(FirebaseConstants.history).child(currentUser.uid).child(track.songId).setValue(track.toJSON())
    }
    
    static func getHistory(completionHandler: @escaping ([Track], Error?) -> Void) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            completionHandler([], nil)
            return
        }
        
        ref.child(FirebaseConstants.history).child(currentUser.uid).observe(.value, with: { (snapshot) in
            
            var tracks: [Track] = []
            for item in snapshot.children {
                if let child = item as? FIRDataSnapshot, let json = child.value as? [String:Any] {
                    if let track = Track(snapshot: json) {
                        tracks.append(track)
                    }
                }
            }
            
            completionHandler(tracks, nil)
        })
    }
    
    static func createSession(trackId: String, completion: (Session) -> Void) {
        guard Session.currentSession == nil else {
            completion(Session.currentSession!)
            return
        }
        
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        
        let sessionInfo: [String: Any] = [FirebaseConstants.track: trackId, FirebaseConstants.time: 0, FirebaseConstants.timeSetAt: FIRServerValue.timestamp(), FirebaseConstants.users: [currentUser.uid: true], FirebaseConstants.state: PlayerState.playing.rawValue]
        
        let sessionRef = ref.child(FirebaseConstants.sessions).childByAutoId()
        sessionRef.setValue(sessionInfo)
        
        let userSessionRef = ref.child(FirebaseConstants.users).child(currentUser.uid).child(FirebaseConstants.session)
        userSessionRef.setValue(sessionRef.key)
        
        userSessionRef.onDisconnectRemoveValue()
        
        Session.currentSession = Session(snapshot: sessionInfo, id: sessionRef.key)
        completion(Session.currentSession!)
    }
    
    static func updateState(state: PlayerState, time: TimeInterval) {
        guard let session = Session.currentSession else {
            return
        }
        
        ref.child(FirebaseConstants.sessions).child(session.id).updateChildValues([FirebaseConstants.state: state.rawValue, FirebaseConstants.timeSetAt: FIRServerValue.timestamp(), FirebaseConstants.time: time])
    }
    
    static func joinSession(id: String, trackChanged: @escaping () -> Void, stateChanged: @escaping () -> Void, timeChanged: @escaping () -> Void) {
        let sesssionRef = ref.child(FirebaseConstants.sessions).child(id)
        
        sesssionRef.child(FirebaseConstants.track).observe(.value, with: { (snapshot) in
            if snapshot.exists(), let trackId = snapshot.value as? String {
                Session.currentSession?.trackId = trackId
                trackChanged()
            }
        })
        
        sesssionRef.child(FirebaseConstants.state).observe(.value, with: { (snapshot) in
            if snapshot.exists(), let stateValue = snapshot.value as? String, let state = PlayerState(rawValue: stateValue) {
                Session.currentSession?.state = state
                
                stateChanged()
            }
        })
        
        sesssionRef.child(FirebaseConstants.time).observe(.value, with: { (snapshot) in
            sesssionRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let sessionInfo = snapshot.value as? [String: Any], let session = Session(snapshot: sessionInfo, id: snapshot.key) else { return }
                
                Session.currentSession?.time = session.time
                Session.currentSession?.timeSetAt = session.timeSetAt
                timeChanged()
            })
        })
    }
}
