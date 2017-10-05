//
//  ViewController.swift
//  SmartCamera
//
//  Created by Yu Sun on 3/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let resultLabel:UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(resultLabel)
        
        //result label constraint
        resultLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        resultLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        resultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        resultLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true 
        
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        // get the back camera of typical iphone
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        // if you do not want catch use question mark
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        
        //get preview layer of camera;
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        //set up preview layer frame otherwise you won't see anything
        previewLayer.frame = view.frame
        
        
        //get image from layer
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer:CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishReq, err) in
            
            //perhaps check err
            guard let results = finishReq.results as? [VNClassificationObservation] else { return }
            
            guard let firstObaservation = results.first else { return }
            
            DispatchQueue.main.async(execute: {
                 self.resultLabel.text = firstObaservation.identifier + " -- with  " + String(firstObaservation.confidence)
            })
           
        }
        try?  VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }

}

