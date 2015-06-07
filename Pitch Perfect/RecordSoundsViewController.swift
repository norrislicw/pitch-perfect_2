//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Norris on 26/5/15.
//  Copyright (c) 2015 Norris. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var pauseRecordingLabel: UILabel!
    @IBOutlet weak var stopRecordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    var isRecording: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isRecording = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the stop button
        stopButton.hidden = true
        // Show the record button
        recordButton.enabled = true
        pauseButton.hidden = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        
        if !(isRecording){

            isRecording = true
        
            // Record user's voice
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
            let recordingName = "my_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
        
            // Setup audio session
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
            // Initialize and prepare the recorder
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
        }
        
        // Hide or show texts, and also the stop button
        stopButton.hidden = false
        recordingInProgress.text = "Recording..."
        pauseRecordingLabel.hidden = false
        stopRecordingLabel.hidden = false
        
        // Disable record button
        recordButton.enabled = false
        pauseButton.hidden = false
        
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            // Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
            // Move to next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        // Hide or display texts
        recordingInProgress.text = "Tap to record"
        pauseRecordingLabel.hidden = true
        stopRecordingLabel.hidden = true
        
        // Stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        // Pause recording
        audioRecorder.pause()
        recordButton.enabled = true
        pauseButton.hidden = true
        recordingInProgress.text = "Tap to continue recording"
        pauseRecordingLabel.hidden = true
    }
    
}

