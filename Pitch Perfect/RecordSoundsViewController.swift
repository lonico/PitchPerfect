//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Laurent Nicolas on 5/11/15.
//  Copyright (c) 2015 Laurent Nicolas. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    let tapToRecordString = "Tap to Record"
    let recordingString = "Recording..."
    let pausedString = "Paused"
    let tryAgain = "Try again!"

    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var tapToPlayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // hide stopRecording button
        stopButton.hidden = true
        tapToPlayLabel.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        recordButton.enabled = true
        recordingStatusLabel.text = tapToRecordString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(sender: UIButton) {
        //record voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)

        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        
        recordButton.enabled = false
        stopButton.hidden = false
        stopButton.enabled = true
        tapToPlayLabel.hidden = false
        pauseButton.hidden = false
        pauseButton.enabled = true
        resumeButton.hidden = false
        resumeButton.enabled = false
        recordingStatusLabel.text = recordingString
        
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        // this will call the delegate, DidFinishRecording
        audioRecorder.stop()
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        pauseButton.enabled = false
        resumeButton.enabled = true
        recordingStatusLabel.text = pausedString
        audioRecorder.pause()
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        pauseButton.enabled = true
        resumeButton.enabled = false
        recordingStatusLabel.text = recordingString
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("showPlaySoundsView", sender: recordedAudio)
        } else {
            println("Recording failure")
            recordButton.enabled = true
            stopButton.hidden = true
            recordingStatusLabel.text = tryAgain
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPlaySoundsView" {
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.recordedAudio = data
        }
    }
}

