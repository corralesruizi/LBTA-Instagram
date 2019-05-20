//
//  CamearaViewController.swift
//  InstagramFirebase
//
//  Created by Developer on 5/20/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class CamearaViewController: UIViewController,AVCapturePhotoCaptureDelegate,UIViewControllerTransitioningDelegate {

    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var vwCametaContainer: UIView!
    @IBOutlet weak var vwPreviewCapture: UIView!
    @IBOutlet weak var imgCapture: UIImageView!
    
   
    var previewLayer:CALayer?
    let output = AVCapturePhotoOutput()
    
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismisser = CustomAnimationDismisser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = self
        setupCaptureSession()
    }

    override func viewDidLayoutSubviews() {
        guard let pvl = previewLayer else {return}
        pvl.frame = vwCametaContainer.bounds
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimationPresentor
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimationDismisser
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        
        print("Capturing photo...")
        
        let settings = AVCapturePhotoSettings()
        
        // do not execute camera capture for simulator
        #if (!arch(x86_64))
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        output.capturePhoto(with: settings, delegate: self)
        #endif
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        let previewImage = UIImage(data: imageData!)
        
        vwCametaContainer.isHidden=false
        imgCapture.image=previewImage
        print("Finish processing photo sample buffer...")
    }
    
    
    @IBAction func SaveAction(_ sender: UIButton) {
        guard let previewImage = imgCapture.image else { return }
        
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
        }) { (success, err) in
            if let err = err {
                print("Failed to save image to photo library:", err)
                return
            }
            
            print("Successfully saved image to library")
            
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully"
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.textColor = .white
                savedLabel.numberOfLines = 0
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.textAlignment = .center
                
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.center = self.vwCametaContainer.center
                
                self.vwCametaContainer.addSubview(savedLabel)
                
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    
                }, completion: { (completed) in
                    //completed
                    
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                        
                    }, completion: { (_) in
                        savedLabel.removeFromSuperview()
                    })
                })
            }
            
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        vwPreviewCapture.isHidden=true
    }
}
