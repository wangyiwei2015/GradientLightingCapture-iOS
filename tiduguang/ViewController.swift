//
//  ViewController.swift
//  tiduguang
//
//  Created by Yiwei Wang on 2020/8/13.
//

import UIKit
import AVFoundation

var stopWatch = CFAbsoluteTimeGetCurrent()

class ViewController: UIViewController {
    
    var savedBrightness = CGFloat(0)
    var timer: Timer?
    var index = -1
    var images: [UIImage] = []
    var captured: [UIImage] = []
    var imageView: UIImageView!
    var countdown = -1
    
    let captureSession = AVCaptureSession()
    let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    let aphotoOutput = AVCapturePhotoOutput()
    let aVideoOutput = AVCaptureVideoDataOutput()
    
    func nextImage(_: Timer?) {
        DispatchQueue.main.async {
            self.index += 1
            if self.index >= self.images.count {self.index = 0}
            self.imageView.image = self.images[self.index]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for name in ["grad1-1", "grad1-2", "grad1-3", "grad1-4"] {
            images.append(UIImage(named: name)!)
        }
        imageView = UIImageView(frame: view.frame)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        view.addSubview(imageView)
        view.bringSubviewToFront(startBtn)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        savedBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1.0
        //timer = Timer.scheduledTimer(withTimeInterval: 1/120, repeats: true, block: nextImage(_:))
        initSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIScreen.main.brightness = savedBrightness
        savedBrightness = 0
        timer?.invalidate()
    }
    
    @IBOutlet weak var startBtn: UIButton!
    @IBAction func start(_ sender: UIButton) {
        sender.isHidden = true
        //imageView.backgroundColor = .white
        nextImage(nil)
        captureSession.startRunning()
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: autoNextCapture(_:))
    }
}

