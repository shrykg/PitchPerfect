//
//  RecordsSoundViewController.swift
//  PitchPerfect
//
//  Created by Shreyak Godala on 02/06/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit
import AVFoundation

class RecordsSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: - Property
    
    var audioRecorder: AVAudioRecorder!
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    

    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI(isRecording: false)
    }

    // MARK: - Actions

    @IBAction func recordButtonTapped(_ sender: UIButton) {

        updateUI(isRecording: true)
        
        // sets up url for saved audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] 
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
        // sets up audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        // sets up audiorecorder and starts recording
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecordingButton(_ sender: UIButton) {

        updateUI(isRecording: false)
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    // MARK: - Audio Recorder Delegate method
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // if audio is saved transition to next screen
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: recorder.url)
        } else {
            
            showAlert()
        }
    }
    
    // Passing recorded URL from RecordVC to PlaysoundsVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: - Helper method to configure UI
    
    func updateUI(isRecording: Bool) {
        
        // for disabling and enabling record and stop buttons and updating label text
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
        recordingLabel.text = isRecording ? "Recording in progress...":"Tap to Record"
    }
    
    func showAlert() {
        let alert = UIAlertController(title:"Recording Failed" , message:"Something went wrong with your recording." , preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

