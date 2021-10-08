//
//  MainViewController.swift
//  VideoRecordAndPlay
//
//  Created by 윤병일 on 2021/09/24.
//

import UIKit
import SnapKit
import AVKit
import MobileCoreServices
import AVFoundation
import AVFAudio

class MainViewController : UIViewController, UINavigationControllerDelegate  {
  //MARK: - Properties
  
  var videoAndImageReview = UIImagePickerController()
  var videoURL : URL?
  
  let recordStartButton : UIButton = {
    let bt = UIButton()
    bt.setTitle("Record Video", for: .normal)
    bt.setTitleColor(.black, for: .normal)
    bt.backgroundColor = .lightGray
    bt.addTarget(self, action: #selector(recordStart), for: .touchUpInside)
    return bt
  }()
  
  let playVideoButton : UIButton = {
    let bt = UIButton()
    bt.setTitle("Play Video", for: .normal)
    bt.setTitleColor(.black, for: .normal)
    bt.backgroundColor = .yellow
    bt.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
    return bt
  }()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  //MARK: - Functions
  private func configureUI() {
    view.backgroundColor = .white
    
    let stack = UIStackView(arrangedSubviews: [recordStartButton, playVideoButton])
    stack.axis = .vertical
    stack.distribution = .fillEqually
    stack.spacing = 10
    
    view.addSubview(stack)
    stack.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalTo(300)
      $0.height.equalTo(400)
    }
    
    func videoAndImageReview(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      videoURL = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL
        print("\(String(describing: videoURL))")
        self.dismiss(animated: true, completion: nil)
    }
  }
  
  //MARK: - @objc func
  @objc func recordStart() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      print("Camera Available")
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = .camera
//      imagePicker.mediaTypes = [kUTTypeMovie as String]
      imagePicker.mediaTypes = ["public.movie"]
//      imagePicker.mediaTypes = ["com.apple.quicktime-movie"]
//      imagePicker.mediaTypes = [kUTTypeQuickTimeMovie as String]
//      imagePicker.mediaTypes = NSArray(objects: UTType.quickTimeMovie) as! [String]
//      var identifier = UTType.quickTimeMovie.identifier
//      identifier = "com.apple.quicktime-movie"
//      imagePicker.mediaTypes = [identifier as String]
//      imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
//      imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
//      imagePicker.mediaTypes = UTType["com.apple.quicktime-movie"]
//      imagePicker.mediaTypes =
      
//      let type = UTType.init("com.apple.quicktime-movie")
//      imagePicker.mediaTypes = [type as String]
      
      imagePicker.allowsEditing = false
      self.present(imagePicker, animated: true, completion: nil)
    } else {
     print("Camera Unavailable")
    }
  }
  
  @objc func playVideo() {
    print("play Video")
    videoAndImageReview.sourceType = .savedPhotosAlbum
    videoAndImageReview.delegate = self
    videoAndImageReview.mediaTypes = ["public.movie"]
    present(videoAndImageReview, animated: true, completion: nil)
  }
  
  @objc func videoSave(_ videoPath : String, didFinishSavingWithError error : Error?, contextInfo info : AnyObject) {
    let title = (error == nil) ? "Success" : "Error"
    let message = (error == nil) ? "Video was saved" : "Video failed to save"
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}

  //MARK: - UIImagePickerControllerDelegate
extension MainViewController : UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true, completion: nil)
    guard let mediaType = info[.mediaType] as? String,
          mediaType == (kUTTypeMovie as String),
          let url = info[.mediaURL] as? URL,
          UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) else {return}
  
    // Handle a movie capture
    UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(videoSave(_:didFinishSavingWithError:contextInfo:)), nil)
  }
  
}
