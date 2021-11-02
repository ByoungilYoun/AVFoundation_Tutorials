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
          bundle.url(forResource: "red", withExtension: assetType)!.absoluteString,
          bundle.url(forResource: "white", withExtension: assetType)!.absoluteString,
          bundle.url(forResource: "blue", withExtension: assetType)!.absoluteString,
      ]
      
      var assets = [String]()
      
      for i in 1...count {
          assets.append(urls[i % urls.count])
      }
      
      return assets
  }
  
  
  //MARK: - @objc func
  @objc func buildTimeLapse(_ sender : Any) {
    let assets = assetList(count: 480)
    
    let timeLapseBuilder = TimeLapseBuilder(delegate: self)
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    timeLapseBuilder.build(with: assets, atFrameRate: 3, type: .mov, toOutputPath: documentPath.appendingPathComponent("AssembledVideo.mov"))
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
    }
  }
  
  func timeLapseBuilder(_ timelapseBuilder: TimeLapseBuilder, didFailWithError error: Error) {
    let alert = UIAlertController(title: "Couldn't build timelapse", message: "\(error)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}
