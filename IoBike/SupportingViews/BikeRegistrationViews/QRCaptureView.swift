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

struct QRCaptureView: UIViewControllerRepresentable {
    typealias UIViewControllerType = QRScanViewController
    let qrScanner = QRScanViewController()
    let onScan: (String) -> Void
    
    public init(onScan: @escaping (String) -> Void) {
        self.onScan = onScan
    }
    
    public func makeCoordinator() -> QRScannerCoordinator {
        return QRScannerCoordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> QRScanViewController {
        qrScanner.delegate = context.coordinator
        return qrScanner
    }
    
    func updateUIViewController(_ uiViewController: QRScanViewController, context: Context) {
        print("updatingQRScanner")
    }
    
    public class QRScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCaptureView
        var qrInSight = false
        
        init(parent: QRCaptureView) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            // Check if the metadataObject array is not nil and it contains at least one object.
            if metadataObjects.count == 0 {
                qrInSight = false
                parent.qrScanner.qrCodeFrameView?.frame = CGRect.zero
                //messageLabel.text = "No QR code is detected"
                return
            }
            
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let qrCodeObject = parent.qrScanner.videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                parent.qrScanner.qrCodeFrameView?.frame = qrCodeObject!.bounds
                
                if let deviceID = metadataObj.stringValue {
                    parent.onScan(deviceID)
                }
            }
        }
    }
    
    class QRScanViewController: UIViewController {
        var captureSession: AVCaptureSession!
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        var qrCodeFrameView: UIView?
        var delegate: QRScannerCoordinator?
        
        override func viewDidLoad() {
            captureSession = AVCaptureSession()
            
            let deviceDiscoverySession =
                AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera],
                                                 mediaType: AVMediaType.video,
                                                 position: .back)
            
            guard let captureDevice = deviceDiscoverySession.devices.first else {
                print("Failed to get the camera device")
                return
            }
            
            do {
                // Get an instance of the AVCaptureDeviceInput class using the previous object.
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                } else {
                    print("Unable to add input")
                    return
                }
                
                // Initialize an AVCaptureMetadataOutput object and set it as the output device to to the capture session.
                let captureMetadataOutput = AVCaptureMetadataOutput()
                
                if captureSession.canAddOutput(captureMetadataOutput) {
                    captureSession.addOutput(captureMetadataOutput)
                    
                    // Set delegate and use the default dispatch queue to execute the call back
                    captureMetadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                    captureMetadataOutput.metadataObjectTypes = [.qr]
                } else {
                    print("Unable to add output")
                    return
                }
            } catch {
                print("Unable to find AVCaptureDevice")
                return
            }
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
        }
    }
}

struct QRScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRCaptureView(onScan: { _ in })
    }
}
