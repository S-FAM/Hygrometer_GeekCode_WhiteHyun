//
//  CityViewController.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/09.
//

import Combine
import UIKit

import SnapKit
import Then

final class CityViewController: UIViewController {
    
    // MARK: - Properties
    
    @Published public var humidity: Int = 0
    public private(set) var id: String = ""
    
    /// 도시 이름을 표시해주는 label 입니다.
    private lazy var cityTitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "서울"
        $0.font = .systemFont(ofSize: 30)
        $0.adjustsFontSizeToFitWidth = true
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
        $0.text = "목을 축이세요"
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.adjustsFontSizeToFitWidth = true
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
        setupConstraints()
    }
    
    // MARK: - Configuration
    
    /// view에 올려놓을 프로퍼티를 설정합니다. `addSubview` 메서드를 여기에 작성합니다.
    private func setupLayouts() {
        view.addSubview(containerView)
        [cityTitleLabel, humidityLabel, phraseLabel].forEach {
            containerView.addArrangedSubview($0)
        }
    }
    
    
    /// 프로퍼티의 제약조건을 설정합니다.
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(56)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
    }
    
    func configure(with model: UserDataModel) {
        cityTitleLabel.text = model.city
        id = model.id
        
        let requestModel = WeatherRequest(
            lat: model.point.y,
            lon: model.point.x,
            appID: Private.weatherSecretKey,
            lang: "ko"
        )
      
        API.weatherInformation(with: requestModel) { [weak self] in
            guard case let .success(result) = $0,
                  let phraseModel = PhraseModel(humidity: result.main.humidity)
            else {
                return
            }
            self?.humidity = result.main.humidity
            self?.humidityLabel.text = "\(result.main.humidity)%"
            // 습도별 문구 아무 거나 선택해서 보여줌
            self?.phraseLabel.text = phraseModel.phrase.randomElement()
        }
    }
}
