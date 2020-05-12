//
//  QRScanner.swift
//  IoBike
//
//  Created by James Lemkin on 5/8/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI

struct QRScanner: UIViewControllerRepresentable {
    typealias UIViewControllerType = QRScanViewController

    func makeUIViewController(context: Context) -> QRScanViewController {
        let qrScanner = QRScanViewController()
        return qrScanner
    }
    
    func updateUIViewController(_ uiViewController: QRScanViewController, context: Context) {
        print("Placeholder")
    }
}

class QRScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    override func viewDidLoad() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            if let session = captureSession {
                session.addInput(input)
                
                // Initialize an AVCaptureMetadataOutput object and set it as the output device to to the capture session.
                let captureMetadataOutput = AVCaptureMetadataOutput()
                session.addOutput(captureMetadataOutput)
                
                // Set delegate and use the default dispatch queue to execute the call back
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = [.qr]
                
                // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                
                // Start video capture.
                session.startRunning()
            }
        } catch {
            print(error)
            return
        }
    }
}

struct QRScanViewController_Previews: PreviewProvider {
    static var previews: some View {
        QRScanner()
    }
}
