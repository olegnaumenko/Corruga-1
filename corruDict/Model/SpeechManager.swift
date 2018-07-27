//
//  SpeechManager.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import Speech

protocol SpeechManagerDelegate {
    
    func speechManagedDidFailAuth(reason:String)
    func speechManagedDidFail(reason:String)
    func speechManagerDidStartRecording()
    func speechManagerDidStopRecording(error:Error?)
    func speechManagerFoundResult(result:String, final:Bool)
}

class SpeechManager {
    
    var delegate:SpeechManagerDelegate?
    
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechResult = SFSpeechRecognitionResult()
    
    private let audioEngine = AVAudioEngine()
    
    private var pauseTimer:Timer?

    init?(localeID:String) {
        if let sp = SFSpeechRecognizer(locale: Locale(identifier: localeID)) {
            self.speechRecognizer = sp
        } else {
            return nil
        }
    }
    
    deinit {
        self.pauseTimer?.invalidate()
    }
    
    func startVoiceSession(localeID:String,
                           duration:Double,
                           result:@escaping (String, Bool)->(),
                           completion:@escaping (Error?)->())
    {
        if self.speechRecognizer.locale.identifier != localeID {
            if let sp = SFSpeechRecognizer(locale: Locale(identifier: localeID)) {
                self.speechRecognizer = sp
            } else {
                completion(NSError.init(domain: "com.corruDict", code: -1, userInfo: [NSLocalizedDescriptionKey:"Unsupported locale"]))
                return
            }
        }
        
        self.requestMicAccess { (allowed) in
            if allowed {
                self.requestAuth { (authorized, errorString) in
                    if (authorized) {
                        do {
                            try self.startRecordingSession(duration: duration, resultBlock: result, completion: completion)
                        } catch {
                            let errorString = "error starting recorder"
                            self.delegate?.speechManagedDidFail(reason: errorString)
                        }
                    }
                }
            }
        }
    }
    
    private func requestMicAccess(responce:@escaping (Bool)->())
    {
        AVAudioSession.sharedInstance().requestRecordPermission { (permitted) in
            responce(permitted)
        }
    }
    
    private func requestAuth(completion:@escaping (_ authorized:Bool, _ errorString:String?)->())
    {
        SFSpeechRecognizer.requestAuthorization { authStatus in

            OperationQueue.main.addOperation {
                
                var alertMsg:String? = nil
                
                switch authStatus {
                case .authorized:
                    completion(true, nil)
                    
                case .denied:
                    alertMsg = "Enable speech recognition in Settings"
                    
                case .restricted, .notDetermined:
                    alertMsg = "Check your internect connection and try again"
                }
                if alertMsg != nil {
                    self.delegate?.speechManagedDidFailAuth(reason: alertMsg!)
                    completion(false, alertMsg)
                }
            }
        }
    }
    
    
    private func startRecordingSession(duration:Double,
                                       resultBlock:@escaping (String, Bool)->(),
                                       completion:@escaping (Error?)->()) throws
    {
        if !audioEngine.isRunning {
            
            let deadlineTime = DispatchTime.now() + duration
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.stopVoiceSession()
            }
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            guard let inputNode = audioEngine.inputNode else { fatalError("There was a problem with the audio engine") }
            guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create the recognition request") }
            
            // Configure request so that results are returned before audio recording is finished
            recognitionRequest.shouldReportPartialResults = true
            
            // A recognition task is used for speech recognition sessions
            // A reference for the task is saved so it can be cancelled
            
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                
                var isFinal = false
                
                self.pauseTimer?.invalidate()
                
                if let result = result {
//                    print("resultFinal: \(result.isFinal)")
                    isFinal = result.isFinal
                    
                    self.speechResult = result
                    
                    let resultString = result.bestTranscription.formattedString;
                    self.delegate?.speechManagerFoundResult(result:resultString , final: isFinal)
                    resultBlock(resultString, isFinal)
                    
                    self.pauseTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                        self.stopVoiceSession()
                    })
                }
                
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    self.delegate?.speechManagerDidStopRecording(error: error)
                    completion(error)
                }
                
            }
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequest?.append(buffer)
            }
            
            print("Begin recording")
            audioEngine.prepare()
            try audioEngine.start()
            
            self.delegate?.speechManagerDidStartRecording()
        }
    }
    
    func stopVoiceSession()
    {
        print("stopping")
        audioEngine.stop()
        recognitionRequest?.endAudio()
        // Cancel the previous task if it's running
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
    }
    
}
