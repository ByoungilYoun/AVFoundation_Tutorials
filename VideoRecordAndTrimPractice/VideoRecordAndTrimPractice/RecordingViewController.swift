//
//  RecordingViewController.swift
//  VideoRecordAndTrimPractice
//
//  Created by 윤병일 on 2021/10/26.
//

import UIKit
import AVFoundation
import RxCocoa
import RxSwift
import CoreMotion
import Then
import SnapKit

class RecordingViewController : UIViewController {
  
  //MARK: - Properties
  
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  //MARK: - Functions
  private func configureUI() {
    view.backgroundColor = .blue
  }
  
  //MARK: - @objc func
  
}
