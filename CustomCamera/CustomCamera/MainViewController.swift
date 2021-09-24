//
//  MainViewController.swift
//  CustomCamera
//
//  Created by 윤병일 on 2021/09/24.
//



import UIKit
import AVFoundation

class MainViewController : UIViewController {
  
  //MARK: - Properties
  
  // Capture Session
  var session : AVCaptureSession?
  
  // Photo Output
  let output = AVCapturePhotoOutput()
  
  // Video Preview
  let previewLayer = AVCaptureVideoPreviewLayer()
  
  // Shutter button
  private let shutterButton : UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    button.layer.cornerRadius = 100 / 2
    button.layer.borderWidth = 10
    button.layer.borderColor = UIColor.white.cgColor
    button.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    return button
  }()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    checkCameraPermissions() 
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    previewLayer.frame = view.bounds
    shutterButton.center = CGPoint(x: view.frame.width / 2, y: view.frame.size.height - 100)
  }
  
  //MARK: - Functions
  private func configureUI() {
    view.backgroundColor = .black
    view.layer.addSublayer(previewLayer)
    view.addSubview(shutterButton)
  }
  
  private func checkCameraPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      // Request
      AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
        guard granted else {
          return
        }
        
        DispatchQueue.main.async {
          self?.setUpCamera()
        }
      }
    case .restricted :
      break
    case .denied :
      break
    case .authorized :
      setUpCamera()
    default:
      break
    }
  }
  
  private func setUpCamera() {
    let session = AVCaptureSession()
    
    if let device = AVCaptureDevice.default(for: .video) {
      do {
        let input = try AVCaptureDeviceInput(device: device)
        if session.canAddInput(input) {
          session.addInput(input)
        }
        
        if session.canAddOutput(output) {
          session.addOutput(output)
        }
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.session = session
        
        session.startRunning()
        self.session = session
        
      } catch {
        print(error)
      }
    }
  }
  
  //MARK: - @objc func
  @objc private func didTapTakePhoto() {
    output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
  }
}

  //MARK: - AVCapturePhotoCaptureDelegate
extension MainViewController : AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    guard let data = photo.fileDataRepresentation() else {
      return
    }
    
    let image = UIImage(data: data)
    
    session?.stopRunning()
    
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFill
    imageView.frame = view.bounds
    view.addSubview(imageView)
    
  }
}
