//
//  CityViewController.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/09.
//

import UIKit

class CityViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 도시 이름을 표시해주는 label 입니다.
    private lazy var cityTitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "서울"
        $0.font = .systemFont(ofSize: 34)
    }
    
    /// 습도(%)를 표시해주는 label 입니다.
    private lazy var humidityLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "19%"
        $0.font = .systemFont(ofSize: 96, weight: .thin)
    }
    
    
    /// 습도에 따른 문구를 표시해주는 label 입니다.
    private lazy var phraseLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "물을 축이세요"
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    
    /// 도시 label, 습도 label, 어구 label을 가지고 수직으로 보여주는 stackview입니다.
    private lazy var containerView = UIStackView().then {
        $0.spacing = 30
        $0.distribution = .fill
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
    }
    
    // MARK: - Configuration
    
    /// view에 올려놓을 프로퍼티를 설정합니다. `addSubview` 메서드를 여기에 작성합니다.
    private func setupLayouts() {
        view.addSubview(containerView)
        [cityTitleLabel, humidityLabel, phraseLabel].forEach {
            containerView.addArrangedSubview($0)
        }
    }
}
