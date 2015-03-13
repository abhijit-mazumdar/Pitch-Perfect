//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Abhijit Mazumdar on 3/11/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        stopAllAudio()
        audioPlayer.currentTime = 0.0
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        stopAllAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate=0.5
        audioPlayer.play()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func playFastAudio(sender: UIButton) {
        stopAllAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate=2.0
        audioPlayer.play()
    }
 
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }
 
    
    func stopAllAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        stopAllAudio()
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAllAudio()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
}
