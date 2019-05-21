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
    
    var captureSession: AVCaptureSession?
    var capturePhotoOutput: AVCapturePhotoOutput?
    @objc var captureDevice: AVCaptureDevice?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = self
        setupCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView else {return}
            statusBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        guard let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView else {return}
        statusBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        guard let pvl = previewLayer else {return}
        pvl.frame = vwCametaContainer.bounds
    }

    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismisser = CustomAnimationDismisser()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimationPresentor
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimationDismisser
    }

    fileprivate func setupCaptureSession() {
        
        DispatchQueue.global(qos: .background).async {
            
            self.captureSession = AVCaptureSession()
            self.capturePhotoOutput = AVCapturePhotoOutput()
            self.captureDevice = AVCaptureDevice.default(for: .video)
            
            let input = try! AVCaptureDeviceInput(device: self.captureDevice!)
            self.captureSession?.addInput(input)
            self.captureSession?.addOutput(self.capturePhotoOutput!)
            self.captureSession?.startRunning()
            
            DispatchQueue.main.async {
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                guard let pvl = self.previewLayer else {return}
                pvl.frame = UIScreen.main.bounds
                self.vwCametaContainer.layer.addSublayer(self.previewLayer!)
            }
        }
    }
    
    @IBAction func CloseCameraAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CaptureAction(_ sender: Any) {
        print("Capturing photo...")
        
        let photoSettings : AVCapturePhotoSettings!
        photoSettings = AVCapturePhotoSettings.init(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.flashMode = .off
        photoSettings.isHighResolutionPhotoEnabled = false
        self.capturePhotoOutput?.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        captureSession?.stopRunning()
        
        guard let data = photo.fileDataRepresentation() else {return}
        
        let previewImage = UIImage(data: data)
        imgCapture.image = previewImage
        vwPreviewCapture.isHidden=false
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
                
                self.vwPreviewCapture.addSubview(savedLabel)
                
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
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            }
            
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        captureSession?.startRunning()
        vwPreviewCapture.isHidden=true
    }
}
