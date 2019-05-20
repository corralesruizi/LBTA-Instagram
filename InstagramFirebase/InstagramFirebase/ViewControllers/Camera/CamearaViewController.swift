//
//  CamearaViewController.swift
//  InstagramFirebase
//
//  Created by Developer on 5/20/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import AVFoundation


class CamearaViewController: UIViewController {

    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var vwCametaContainer: UIView!
    
    var previewLayer:CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCaptureSession()
    }

    override func viewDidLayoutSubviews() {
        guard let pvl = previewLayer else {return}
        pvl.frame = vwCametaContainer.bounds
    }
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        //1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("Could not setup camera input:", err)
        }
        
        //2. setup outputs
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //3. setup output preview
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        guard let pvl = previewLayer else {return}
        vwCametaContainer.layer.addSublayer(pvl)
        captureSession.startRunning()
    }
    
    @IBAction func CloseCameraAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CaptureAction(_ sender: Any) {
        print("Photo captured")
        
    }
    

}
