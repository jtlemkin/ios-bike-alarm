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

struct QRScanView: View {
    @EnvironmentObject var device: Device
    var onScan : (String) -> Void
    var onUnableToAccessCamera : () -> Void
    @State var badQRCodeFound = false
    
    var body: some View {
         ZStack {
            Color.appThemeBlue.edgesIgnoringSafeArea(.top)
        
            Text("Sorry we're having trouble accessing the camera. Please go to the settings app and disable camera permission to continue.")
           
            VStack {
                Text("Scan Bike Code")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(.top)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.appThemeBlue)
               
                QRCaptureView(parent: self)
            }
            
            VStack {
                if badQRCodeFound {
                    Spacer()
                    
                    Text("Invalid QR code found")
                        .foregroundColor(.red)
                        .font(.title)
                }
            }
       }
    }
}

struct QRScanView_Previews: PreviewProvider {
    static var previews: some View {
        QRScanView(onScan: { _ in }, onUnableToAccessCamera:{})
    }
}

struct QRCaptureView: UIViewControllerRepresentable {
    typealias UIViewControllerType = QRScanViewController
    let qrScanViewController = QRScanViewController()
    let qrScanView: QRScanView
    
    public init(parent: QRScanView) {
        self.qrScanView = parent
    }
    
    public func makeCoordinator() -> QRScannerCoordinator {
        return QRScannerCoordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> QRScanViewController {
        qrScanViewController.delegate = context.coordinator
        return qrScanViewController
    }
    
    func updateUIViewController(_ uiViewController: QRScanViewController, context: Context) {
        
    }
    
    public class QRScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var qrCaptureView: QRCaptureView
        var qrInSight = false
        
        init(parent: QRCaptureView) {
            self.qrCaptureView = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            // Check if the metadataObject array is not nil and it contains at least one object.
            if metadataObjects.count == 0 {
                qrInSight = false
                qrCaptureView.qrScanViewController.qrCodeFrameView?.frame = CGRect.zero
                //messageLabel.text = "No QR code is detected"
                return
            }
            
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let qrCodeObject = qrCaptureView.qrScanViewController.videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCaptureView.qrScanViewController.qrCodeFrameView?.frame = qrCodeObject!.bounds
                
                if let deviceID = metadataObj.stringValue {
                    if deviceID.count == 4 && isHexadecimal(number: deviceID) && !UserDefaultsBackedDeviceStorage.getAllDeviceIDs().contains(deviceID) {
                        qrCaptureView.qrScanView.onScan(deviceID)
                    } else {
                        qrCaptureView.qrScanView.badQRCodeFound = true
                    }
                }
            }
        }
        
        func setError(withMessage message: String) {
            qrCaptureView.qrScanView.device.errorMessage = message
        }
    }
    
    class QRScanViewController: UIViewController {
        var captureSession: AVCaptureSession!
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        var qrCodeFrameView: UIView?
        var delegate: QRScannerCoordinator?
        
        override func viewDidLoad() {
            AVCaptureDevice.requestAccess(for: .video) { success in
                if !success {
                    self.delegate?.qrCaptureView.qrScanView.onUnableToAccessCamera()
                    self.delegate?.setError(withMessage: "Error: Unable to access video")
                }
            }
            
            captureSession = AVCaptureSession()
            
            let deviceDiscoverySession =
                AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera],
                                                 mediaType: AVMediaType.video,
                                                 position: .back)
            
            guard let captureDevice = deviceDiscoverySession.devices.first else {
                delegate?.setError(withMessage: "Failed to get the camera device")
                return
            }
            
            do {
                // Get an instance of the AVCaptureDeviceInput class using the previous object.
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                } else {
                    delegate?.setError(withMessage: "Unable to add input")
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
                    delegate?.setError(withMessage: "Unable to add output")
                    return
                }
            } catch {
                delegate?.setError(withMessage: "Unable to find AVCaptureDevice")
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
