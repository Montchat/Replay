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
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var captureProgressView: CaptureProgress!
    @IBOutlet weak var captureProgressInner: UIView!
    
    let hasCamera = UIImagePickerController.isSourceTypeAvailable(.Camera)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard hasCamera else { return }
        
        picker.sourceType = .Camera
        picker.showsCameraControls = false
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        
        recordStatusView.layer.cornerRadius = recordStatusView.frame.width / 2
        captureProgressInner.layer.cornerRadius = captureProgressInner.frame.height
//        switchCameraButton.layer.cornerRadius = switchCameraButton.frame.width / 2
        
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
        captureProgressInner.frame.size.height += 0.10
        captureProgressInner.frame.size.width += 0.10
        print(captureProgressInner.frame.size.width)
        captureProgressInner.layer.cornerRadius = captureProgressView.frame.size.height / 2
        
        if captureTime >= 10 {
            endCapture()

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isCapturing = true
        recordStatusView.isRecording = true
        captureProgressView.hidden = false
        captureProgressInner.hidden = false 
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateCaptureTime", userInfo: nil, repeats: true)
        picker.startVideoCapture()
        print("worked")
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let translation = touch.locationInView(view)
            captureProgressView.center = CGPoint(x: translation.x, y: translation.y)
            captureProgressInner.center = CGPoint(x: translation.x, y: translation.y)
            
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        endCapture()
        captureProgressView.hidden = false

        
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

