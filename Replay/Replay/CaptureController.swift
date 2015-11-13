//
//  ViewController.swift
//  Replay
//
//  Created by Joe E. on 11/12/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

private let REPLAY_VC = "ReplayVC"

class CaptureController: UIViewController {
    
    //MARK: - Properties
    let picker = UIImagePickerController()
    var timer: NSTimer?
    
    //MARK: - @IBOutlets
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var recordStatusView: UIView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.sourceType = .Camera
        picker.showsCameraControls = false
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        
        view.layoutIfNeeded()
        
        liveView.addSubview(picker.view)

    }
    
    override func viewDidLayoutSubviews() {
        picker.view.frame = liveView.frame
        print(picker.view.frame)
        
    }
    
    var captureTime:Double = 0.0
    var isCapturing = false
    
    func updateCaptureTime() {
        captureTime += 0.01
        
        if captureTime >= 10 {
            endCapture()

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isCapturing = true
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateCaptureTime", userInfo: nil, repeats: true)
        recordStatusView.backgroundColor = UIColor.redColor()
        picker.startVideoCapture()
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        endCapture()
        
    }
    
    func endCapture() {
        guard isCapturing else { return }
        
        isCapturing = false
        timer?.invalidate()
        timer = nil
        recordStatusView.backgroundColor = UIColor.lightGrayColor()
        picker.stopVideoCapture()
        
    }

}

extension CaptureController : UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard captureTime > 1 else { return }
        
        guard let url = info[UIImagePickerControllerMediaURL] as? NSURL else { return }
        guard let replayVC = storyboard?.instantiateViewControllerWithIdentifier(REPLAY_VC) as? ReplayController else { return }
        replayVC.url = url
        
        navigationController?.pushViewController(replayVC, animated: true)
        
    }
    
}

extension CaptureController: UINavigationControllerDelegate {

}
