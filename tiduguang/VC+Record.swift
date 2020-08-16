//
//  VC+Record.swift
//  tiduguang
//
//  Created by Yiwei Wang on 2020/8/13.
//

import UIKit
import AVFoundation

extension ViewController {
    
    func initSession() {
        
        //aphotoOutput.isHighResolutionCaptureEnabled = true
        
        do {try videoDevice!.lockForConfiguration()
            videoDevice!.exposureMode = .locked
            videoDevice!.setExposureModeCustom(duration: CMTimeMake(value: 1, timescale: 100), iso: 800, completionHandler: nil)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        
        self.captureSession.sessionPreset = .hd1920x1080
        let videoInput = try! AVCaptureDeviceInput(device: videoDevice!)
        captureSession.addInput(videoInput)
        
        captureSession.addOutput(self.aphotoOutput)
        //captureSession.addOutput(self.aVideoOutput)
        //aVideoOutput.alwaysDiscardsLateVideoFrames = true
        //aVideoOutput.setSampleBufferDelegate(self, queue: .init(label: "VIDEO_OUTPUT_QUEUE"))
        //videoInput.videoMinFrameDurationOverride = CMTimeMake(value: 1, timescale: 60)
        
        //captureSession.startRunning()
    }
    
    func autoNextCapture(_: Timer?) {
        countdown = 12
        //captureSession.startRunning()
        DispatchQueue.main.async {
            stopWatch = CFAbsoluteTimeGetCurrent()
            self.capturePhoto()
        }
    }
    
    func capturePhoto() {
        let s = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
        //s.isHighResolutionPhotoEnabled = true
        s.flashMode = .off
        s.isDepthDataDeliveryEnabled = false
        aphotoOutput.capturePhoto(with: s, delegate: self)
    }

}

/*
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if self.countdown > 0 {
            self.countdown -= 1
            DispatchQueue.main.async {
                let image = CMSampleBufferGetImageBuffer(sampleBuffer)!
                self.captured.append(image.convert())
            }
            self.nextImage(nil)
        } else {
            if self.countdown == 0 {
                self.captureSession.stopRunning()
                DispatchQueue.main.async {
                    self.imageView.image = nil
                    self.startBtn.isHidden = false
                }
                self.countdown = -1
                UIScreen.main.brightness = self.savedBrightness
                self.savedBrightness = 0
                DispatchQueue.main.async {
                    for image in self.captured {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                }
                print("done save")
            }
        }
    }
}
*/


extension ViewController: AVCapturePhotoCaptureDelegate {
    
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
//    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print(error!)
            return
        }
        guard let imageData = photo.fileDataRepresentation() else {return}
        DispatchQueue.main.async {
            //UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
            DispatchQueue.main.async {
                self.captured.append(UIImage(data: imageData)!)
            }
        }
    }
    
//    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
//    }
    
//    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
//    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        if countdown > 0 {
            countdown -= 1
            self.nextImage(nil)
            self.capturePhoto()
        } else {
            self.captureSession.stopRunning()
            DispatchQueue.main.async {
                for image in self.captured {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
                //print("12 photos in \((CFAbsoluteTimeGetCurrent() - stopWatch) * 1000) ms")
                let tl = UILabel(frame: CGRect(x: 20, y: 30, width: 800, height: 100))
                tl.text = "12 photos in \((CFAbsoluteTimeGetCurrent() - stopWatch) * 1000) ms"
                self.view.addSubview(tl)
                //UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            }
            return
        }
    }
}
