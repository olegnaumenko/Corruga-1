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
        do {
            if #available(iOS 10.0, *) {
                try asession.setCategory(AVAudioSession.Category.playback, mode:AVAudioSession.Mode.default)
            }
        } catch let error {
            print("could not set avsession category: \(error)")
        }
        do {
            try asession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
            print("could not activate avsession: \(error)")
        }
    }
    
    func deactivate() {
        let asession = AVAudioSession.sharedInstance()
        do {
            try asession.setCategory(AVAudioSession.Category.ambient, mode:AVAudioSession.Mode.default)
            try asession.setActive(false)
        } catch let error {
            print("could not deconfigure avsession: \(error)")
        }
    }
}
