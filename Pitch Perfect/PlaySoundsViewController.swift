//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Laurent Nicolas on 5/13/15.
//  Copyright (c) 2015 Laurent Nicolas. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var recordedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var url = recordedAudio.filePathUrl
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
        audioEngine = AVAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        audioEngine.stop()
        super.viewWillDisappear(animated)
    }
    
    enum SoundEffect : Int {
        case Pitch
        case Rate
        case Reverb
        case Echo
    }
    
    func playAudioWithEffect(effect: SoundEffect, value: Float) {
        // Since AVAudioUnitTimePitch can control the rate, I refactored the code to
        // not use AVAudioPlayer.  It is assumed that only one element needs to be
        // controlled at a time
        
        audioEngine.stop()
        audioEngine.reset()
        
        var playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        
        var audioEffect:AVAudioUnit!
        
        switch effect {
        case SoundEffect.Reverb:
            var audioReverb = AVAudioUnitReverb()
            //audioEngine.attachNode(audioReverb)
            audioReverb.wetDryMix = value
            audioReverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
            audioEffect = audioReverb
        case SoundEffect.Echo:
            var audioDelay = AVAudioUnitDelay()
            //The feedback is specified as a percentage. The default value is 50%. The valid range of values is -100% to 100%.
            audioDelay.feedback = 50
            //The blend is specified as a percentage. The default value is 100%. The valid range of values is 0% (all dry) through 100% (all wet).
            audioDelay.wetDryMix = value
            audioEffect = audioDelay
        case SoundEffect.Pitch, SoundEffect.Rate:
            var audioPitchEffect = AVAudioUnitTimePitch()
            if (effect == SoundEffect.Pitch) {
                // In "cents". The default value is 1.0. The range of values is -2400 to 2400
                audioPitchEffect.pitch = value
            } else {
                //The default value is 1.0. The range of supported values is 1/32 to 32.0.
                audioPitchEffect.rate = value
            }
            audioEffect = audioPitchEffect
        }
        
        audioEngine.attachNode(audioEffect)
        audioEngine.connect(playerNode, to: audioEffect, format: playerNode.outputFormatForBus(0))
        audioEngine.connect(audioEffect, to: audioEngine.outputNode, format:
            playerNode.outputFormatForBus(0))
        audioEngine.startAndReturnError(nil)
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        playerNode.play()
    }
    
    func playAudioWithSpeed(rate: Float) {
        // plays a sound using rate
        // assumes rate is valid 1/32 <= rate <= 32
        playAudioWithEffect(SoundEffect.Rate, value: rate)
    }
    
    func playAudioWithPitch(pitch: Float) {
        playAudioWithEffect(SoundEffect.Pitch, value: pitch)
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        // plays a sound slowly
        playAudioWithSpeed(0.5)
    }
    
    @IBAction func playFastSound(sender: UIButton) {
        // plays a sound fast
        playAudioWithSpeed(2.0)
    }
    
    @IBAction func stopSound(sender: UIButton) {
        audioEngine.stop()
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        playAudioWithPitch(1000)
    }
    
    @IBAction func playDarthVaderSound(sender: UIButton) {
        playAudioWithPitch(-1000)
    }
    
    @IBAction func playEchoSound(sender: UIButton) {
        playAudioWithEffect(SoundEffect.Echo, value: 25)
    }
    
    @IBAction func playReverbSound(sender: UIButton) {
        playAudioWithEffect(SoundEffect.Reverb, value: 50)
    }
}
