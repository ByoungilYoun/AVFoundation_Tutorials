//
//  MainViewController.swift
//  VideoRecordAndPlay
//
//  Created by 윤병일 on 2021/09/24.
//

import UIKit
import SnapKit

class MainViewController : UIViewController {
  
  //MARK: - Properties
  
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
  }
  
  //MARK: - @objc func
  @objc func recordStart() {
    print("record Start")
  }
  
  @objc func playVideo() {
    print("play Video")
  }
}
