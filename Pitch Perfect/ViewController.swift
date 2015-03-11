//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Abhijit Mazumdar on 3/10/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        recordingInProgress.hidden=false
        
        //TODO: Record the user's voice
        println("In recordAudio")
    }

    @IBOutlet weak var recordingInProgress: UILabel!
}

