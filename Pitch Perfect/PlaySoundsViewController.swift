//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Matthew Dean Furlo on 3/23/15.
//  Copyright (c) 2015 FurloBros. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    
    //First create an instance of AVAaudioPlayer, recievedAudio, AVAudioEngine and AVAudioFile
    //These are in the global scope of the.
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this performs the intial setup right after the view loads. It is exicuted only once.
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func playSlow(sender: UIButton) {
        //this function plays the recroded audio file at a slow pace when called
        playWithVariableSpeed(0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        //this function plays the recroded audio file at a slow pace when called
        playWithVariableSpeed(2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        //this function plays the recorded audio file at a high pitch when called
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthUdio(sender: UIButton) {
        //this function plays the recorded audio file at a low pitch when called
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        //stops all audio
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        //stop all current audio and resets the audio engine
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //create a PlayerNode and attach it to the audioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //create an AVAudioUnitTimePitch instance and attach it to the audioEngine.
        //this controls the pitch of the playback, the pitch rate is passed as a float from the function call
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //attach the changePitch affect and connect that to the outPutNode. this preps for playback
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        //This grabs the path for the audio file that had been recorded and preps it for playback
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        //initiate playback
        audioPlayerNode.play()
    }
    
    func playWithVariableSpeed(speed: Float){
        
        //stop all audio and reset the time. The speed of the play back is passed as a float in to the function call
        //finally, playback begins
        audioPlayer.stop()
        audioEngine.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    

}
