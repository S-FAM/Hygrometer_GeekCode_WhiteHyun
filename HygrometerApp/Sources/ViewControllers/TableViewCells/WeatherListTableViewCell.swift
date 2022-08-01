//
//  WeatherListTableViewCell.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/17.
//

import UIKit

class WeatherListTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    let locationNameLabel = UILabel()
    let humidityLabel = UILabel()
    let plusView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setWeatherListTabeViewCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWeatherListTabeViewCellLayout() {
        contentView.backgroundColor = .clear
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        containerView.backgroundColor = .themeColor
        containerView.layer.cornerRadius = 20
        //그림자
        containerView.layer.shadowColor = ShadowSet.shadowColor
        containerView.layer.shadowOffset = ShadowSet.shadowOffsetStrong
        containerView.layer.shadowRadius = ShadowSet.shadowRadius
        containerView.layer.shadowOpacity = ShadowSet.shadowOpacityWeak
        containerView.layer.masksToBounds = false
        
        self.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.leading.equalTo(containerView).offset(20)
            make.width.equalTo(100)
        }
        locationNameLabel.text = "수원시"
        locationNameLabel.textColor = .white
        locationNameLabel.font = UIFont.boldSystemFont(ofSize: 20)

        self.addSubview(humidityLabel)
        humidityLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationNameLabel)
            make.trailing.equalTo(containerView).inset(20)
            make.width.equalTo(70)
        }
        humidityLabel.text = "40%"
        humidityLabel.textColor = .white
        humidityLabel.font = UIFont.boldSystemFont(ofSize: 17)

    }
}
