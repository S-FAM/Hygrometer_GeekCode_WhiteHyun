//
//  WeatherListTableViewCell.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/17.
//

import UIKit
import Lottie

class WeatherListTableViewCell: UITableViewCell {
    
    let humidityLabel = UILabel()
    let locationNameLabel = UILabel()
    let weatherAnimationView = AnimationView()
    
    lazy var cellImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 20
        $0.layer.shadowColor = ShadowSet.shadowColor
        $0.layer.shadowOffset = ShadowSet.shadowOffsetStrong
        $0.layer.shadowRadius = ShadowSet.shadowRadius
        $0.layer.shadowOpacity = ShadowSet.shadowOpacityWeak
        $0.layer.masksToBounds = false
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        setDetail()
        setBackground(isDark: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDetail(){
        backgroundColor = .clear
        selectionStyle = .none

        humidityLabel.font = UIFont.boldSystemFont(ofSize: 40)
        locationNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        weatherAnimationView.backgroundColor = .clear

        [ humidityLabel, locationNameLabel ].forEach {
            $0.text = ""
            $0.textColor  = .white
        }

    }
    
    func setLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(cellImageView)
        [ locationNameLabel, humidityLabel, weatherAnimationView ].forEach {
            cellImageView.addSubview($0)
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.85)
        }
        
        cellImageView.snp.makeConstraints {
            $0.edges.equalTo(containerView)
        }
        
        humidityLabel.snp.makeConstraints {
            $0.top.equalTo(containerView).offset(30)
            $0.leading.equalTo(containerView).offset(20)
            $0.width.equalTo(containerView).multipliedBy(0.4)
        }
        
        locationNameLabel.snp.makeConstraints {
            $0.top.equalTo(humidityLabel.snp.bottom).offset(20)
            $0.leading.equalTo(containerView).offset(20)
            $0.width.equalTo(200)
        }
        
        weatherAnimationView.snp.makeConstraints {
            $0.centerY.equalTo(cellImageView)
            $0.height.width.equalTo(cellImageView.snp.height).multipliedBy(0.7)
            $0.trailing.equalTo(cellImageView).inset(20)
        }
    }
    
        /// 로티애니메이션 전환
        /// - Parameters:
        ///   - AnimationView: 전환할 애니메이션뷰
        ///   - animationName: JSON파일이름
        /// searchPath는 JSON 파일 위치에 맞게 수정해야한다
    func setAnimation(_ animationView: AnimationView, imageName: String) {
            
            let animation = Animation.named(imageName)//, subdirectory: "Animations")
            if animation == nil { print("nil") }
            
            let imageProvider = BundleImageProvider(bundle : Bundle.main, searchPath:"Resouce/")
            animationView.imageProvider = imageProvider
            animationView.animation = animation
            animationView.play()
            animationView.loopMode = .loop
        }
        
        /**
         - weatherStorm: 번개, 비
         - weatherWindy: 바람 , 구름
         - weatherThunder: 번개
         - weatherSunny: 화창
         - weatherPartlyShower: 화창, 비
         - weatherMist: 안개
         - weatherSnow: 눈
         - weatherStormShowersday: 화창, 번개, 비
         - weatherFoggy: 안개 + 햇빛 - 겹침-
         - weatherFoggyPartlyCloudy: 화창, 구름 - 겹침-
         */
    
    func setBackground(isDark: Bool) {
        
        let imageName = isDark ? "HygrometerCellDark" : "HygrometerCellLight"
        let fontColor = isDark ? UIColor.white : UIColor.black
        cellImageView.image = UIImage(named: imageName)
        [ locationNameLabel, humidityLabel ].forEach {
            $0.textColor = fontColor
        }
        
    }
    
    func configure(with model: ListViewCellViewModel) {
        locationNameLabel.text = model.city
        humidityLabel.text = model.humidity
        setAnimation(weatherAnimationView, imageName: model.animationName)
    }
}
