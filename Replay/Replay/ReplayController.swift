//
//  ReplayController.swift
//  Replay
//
//  Created by Joe E. on 11/12/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ReplayController: UIViewController {
    
    var url:NSURL!
    var videoPlayer = AVPlayerViewController()
    
    override func viewDidAppear(animated: Bool) {
        guard url != nil else { return print("URL not set") }
        
        view.addSubview(videoPlayer.view)
        videoPlayer.view.frame = view.frame
        videoPlayer.player = AVPlayer(URL: url)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
