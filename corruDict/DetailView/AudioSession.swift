//
//  AudioSession.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/18/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import AVFoundation

struct AudioSession
{
    func activate() {
        let asession = AVAudioSession.sharedInstance()
        let mode = AVAudioSessionModeDefault
        let category = AVAudioSessionCategoryPlayback
        do {
            try asession.setCategory(category, mode:mode)
        } catch let error {
            print("could not set avsession category: \(error)")
        }
        do {
            try asession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch let error {
            print("could not activate avsession: \(error)")
        }
    }
    
    func deactivate() {
        let asession = AVAudioSession.sharedInstance()
        do {
            try asession.setCategory(AVAudioSessionCategoryAmbient)
            try asession.setActive(false)
        } catch let error {
            print("could not deconfigure avsession: \(error)")
        }
    }
}
