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
        setDetail()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDetail(){
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .themeColor
        containerView.layer.cornerRadius = 20
        //그림자
        containerView.layer.shadowColor = ShadowSet.shadowColor
        containerView.layer.shadowOffset = ShadowSet.shadowOffsetStrong
        containerView.layer.shadowRadius = ShadowSet.shadowRadius
        containerView.layer.shadowOpacity = ShadowSet.shadowOpacityWeak
        containerView.layer.masksToBounds = false
        
        locationNameLabel.text = "수원시"
        locationNameLabel.textColor = .white
        locationNameLabel.font = UIFont.boldSystemFont(ofSize: 15)

        humidityLabel.text = "40%"
        humidityLabel.textColor = .white
        humidityLabel.font = UIFont.boldSystemFont(ofSize: 15)

    }
    
    func setWeatherListTabeViewCellLayout() {
        self.contentView.addSubview(containerView)
        [locationNameLabel, humidityLabel, plusView].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        
        locationNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.leading.equalTo(containerView).offset(20)
            make.width.equalTo(200)
        }
        
        humidityLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(containerView).inset(10)
        }
    }
    
    func configure(with model: ListViewCellViewModel) {
        locationNameLabel.text = model.city
        humidityLabel.text = model.humidity
    }
}
