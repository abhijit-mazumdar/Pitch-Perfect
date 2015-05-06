//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Abhijit Mazumdar on 3/10/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var hasGivenRecordingPermission:Bool = false
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var recordingInProgress: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled=true
        recordingInProgress.text = "Tap to record"
        recordingInProgress.hidden=false
        
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for user user permission to record
        var session = AVAudioSession.sharedInstance()
        session.requestRecordPermission({(response: Bool) in
            self.hasGivenRecordingPermission = response
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Records the audio after setting file name and location of the generated sound file
    @IBAction func recordAudio(sender: UIButton) {
        
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordingInProgress.text = "Recording"
        recordButton.enabled=false
        
        //Check if user gave permission
        
        if (hasGivenRecordingPermission)  {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            var error: NSError?
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            if let e = error {
                //(do error handling)
                println(e.description)
            } else {
                
                audioRecorder.delegate = self
                audioRecorder.meteringEnabled = true
                audioRecorder.record()
            }
        } else {
            
            var alertViewController = UIAlertController(title: "No Permission", message: "You didn't give us permission to record!", preferredStyle: UIAlertControllerStyle.Alert)
            var alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertViewController.addAction(alertAction)
            self.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
    

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool){
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl : recorder.url, title : recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled=true
            stopButton.hidden=true
        }
    }
    
    //Get the recorded data and pass it along to the next screen
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as!
            PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}

