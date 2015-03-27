//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Matthew Dean Furlo on 3/16/15.
//  Copyright (c) 2015 FurloBros. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // create an instance of AVAudioRecorder and Recorded Audio.
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    //Creat an instance of AVAudioSession
    var session = AVAudioSession.sharedInstance()
    
    //create outlet for the two buttons and lable so we can control them lower in our code.
    @IBOutlet weak var recording: UILabel!
    @IBOutlet weak var recordAudio: UIButton!
    @IBOutlet weak var stopRecord: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //make sure that each button is in the propper state: The stop button is hidden, the recordButton is enabled, the recording text says "tap to record"
        stopRecord.hidden = true
        recordAudio.enabled = true
        recording.hidden = false
        recording.text = "tap to record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        //when the recordButton is tapped, chage the lable text, make the stopButton visible and disable the recordAudio Button so it can't be tapped again while recording.
        recording.text = "recording"
        stopRecord.hidden = false
        recordAudio.enabled = false
        
        //this gets the directory for where the audio file is going to be stored
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //the path will be given a unique name based on a time stamp, this formats the time stamp and amends it to the file path. Finally it prints the whole file path for verification.
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //start the "Play and Record" Category of the audioSession
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //create an AVAudioRecord instance, set it as it's own delegate, enable metering then finally record.
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool){
        if(flag){
            //save the recorded audio
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathUrl: recorder.url)
            
            //Move to the next scene aka perform segue
            session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            //reset the buttons so we can try again if it doesn't work!
            println("recording was not successful")
            recordAudio.enabled = true
            stopRecord.hidden = true
            recording.text = "Audio didn't save, tap to try again"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //this overides the prepareForSegue function, tying to the completeion of the record function. Also, we send the RecordedAudio instance carrying the Model to the PlaySoundsViewController
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    

    @IBAction func stopRecord(sender: UIButton) {
        //when the stopRecord button is tapped, hide the stop button, that way if the app hangs during processing no buttons will be available.
        recording.hidden = true
        
        //stop the audioRecorder and turn off the
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

