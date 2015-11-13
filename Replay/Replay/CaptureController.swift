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

@IBDesignable
class CaptureController: UIViewController {
    
    //MARK: - Properties
    let picker = UIImagePickerController()
    var timer: NSTimer?
    
    //MARK: - @IBOutlets
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var recordStatusView: RecordStatus!
    @IBOutlet weak var captureProgressView: CaptureProgress!
    
    let hasCamera = UIImagePickerController.isSourceTypeAvailable(.Camera)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        captureProgressView.hidden = true
        
        guard hasCamera else { return }
        
        picker.sourceType = .Camera
        picker.showsCameraControls = false
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        
        recordStatusView.layer.cornerRadius = recordStatusView.frame.width / 2

        
        view.layoutIfNeeded()
        
        liveView.addSubview(picker.view)

    }
    
    override func viewDidLayoutSubviews() {
        picker.view.frame = liveView.frame
        print(picker.view.frame)
        
    }
    
    var captureTime:Double = 0.0
    let maxCaptureTime: Double = 10.0
    var isCapturing = false
    
    func updateCaptureTime() {
        captureTime += 0.05
        
        captureProgressView.progressAmount = CGFloat(captureTime / maxCaptureTime) * 100 
        print(captureProgressView.progressAmount)
        
        if captureTime >= maxCaptureTime {
            endCapture()

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if captureTime < 1 { captureTime = 0 } else { return }
        
        moveProgress(touches)
        isCapturing = true
        recordStatusView.isRecording = true

        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "updateCaptureTime", userInfo: nil, repeats: true)
        picker.startVideoCapture()
        print("worked")
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        moveProgress(touches)
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        captureProgressView.hidden = true
        endCapture()
        
    }
    
    func moveProgress(touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        captureProgressView.hidden = false
        captureProgressView.center = touch.locationInView(view)
        
    }
    
    func endCapture() {
        guard isCapturing else { return }
        recordStatusView.isRecording = false
        isCapturing = false
        timer?.invalidate()
        timer = nil
        recordStatusView.backgroundColor = UIColor.lightGrayColor()
        
        guard hasCamera else { return }
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

