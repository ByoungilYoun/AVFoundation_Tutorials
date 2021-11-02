//
//  ViewController.swift
//  MyTimeLapseBuilderPractice
//
//  Created by 윤병일 on 2021/11/02.
//

import UIKit
import SnapKit
import AVKit


class ViewController: UIViewController {

  
  //MARK: - Properties
  let timeLaspseBuilderButton : UIButton = {
    let bt = UIButton()
    bt.setTitle("Build Timelapse", for: .normal)
    bt.setTitleColor(.black, for: .normal)
    bt.addTarget(self, action: #selector(buildTimeLapse), for: .touchUpInside)
    return bt
  }()
  
  let myProgressView : UIProgressView = {
    let v = UIProgressView()
    v.progress = 1
    v.progressTintColor = .lightGray
    return v
  }()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  //MARK: - Functions
  private func configureUI() {
    view.backgroundColor = .white
    
    [timeLaspseBuilderButton, myProgressView].forEach {
      view.addSubview($0)
    }
    
    timeLaspseBuilderButton.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.height.equalTo(30)
    }
    
    myProgressView.snp.makeConstraints {
      $0.top.equalTo(timeLaspseBuilderButton.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
    }
  }
  
  private func assetList(count: Int) -> [String] {
      let assetType = "jpg"
      let bundle = Bundle.main
      let urls = [
          bundle.url(forResource: "11", withExtension: assetType)!.absoluteString,
          bundle.url(forResource: "21", withExtension: assetType)!.absoluteString,
          bundle.url(forResource: "31", withExtension: assetType)!.absoluteString,
//        bundle.url(forResource: "white", withExtension: assetType)!.absoluteString,
//        bundle.url(forResource: "blue", withExtension: assetType)!.absoluteString,
//        bundle.url(forResource: "red", withExtension: assetType)!.absoluteString,
      ]
      
      var assets = [String]()
      
      for i in 1...count {
          assets.append(urls[i % urls.count])
      }
      
      return assets
  }
  
  
  //MARK: - @objc func
  @objc func buildTimeLapse(_ sender : Any) {
    self.myProgressView.progress = 0
    // 1분에 1장 -> 1시간 60장, 5시간 300장, 8시간 480장
    // 1분에 2장 -> 1시간 120장, 5시간 600장, 8시간 960장
    // 1분에 3장 -> 1시간 180장, 5시간 900장, 8시간 1440장
    // 1분에 4장 -> 1시간 240장, 5시간 1200장, 8시간 1920장
    let assets = assetList(count: 1920)
    
    let timeLapseBuilder = TimeLapseBuilder(delegate: self)
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    timeLapseBuilder.build(with: assets, atFrameRate: 30, type: .mov, toOutputPath: documentPath.appendingPathComponent("AssembledVideo.mov"))
  }
}

  //MARK: - TimelapseBuilderDelegate
extension ViewController : TimelapseBuilderDelegate {
  func timeLapseBuilder(_ timelapseBuilder: TimeLapseBuilder, didMakeProgress progress: Progress) {
    DispatchQueue.main.async {
      self.myProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
    }
  }
  
  func timeLapseBuilder(_ timelapseBuilder: TimeLapseBuilder, didFinishWithURL url: URL) {
    DispatchQueue.main.async {
        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(url: url)
        self.present(playerVC, animated: true) {
        self.myProgressView.setProgress(0, animated: true)
      }
        UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil) // 사진 앨범에 저장
    }
  }
  
  func timeLapseBuilder(_ timelapseBuilder: TimeLapseBuilder, didFailWithError error: Error) {
    let alert = UIAlertController(title: "Couldn't build timelapse", message: "\(error)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}
