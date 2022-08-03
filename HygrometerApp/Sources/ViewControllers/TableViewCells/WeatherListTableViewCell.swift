//
//  WeatherListTableViewCell.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/17.
//

import UIKit

class WeatherListTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    let humidityLabel = UILabel()
    let locationNameLabel = UILabel()
    let plusView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setWeatherListTabeViewCellLayout()
        setDetail()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDetail(){
        containerView.backgroundColor = .themeColor
        containerView.layer.cornerRadius = 20
        //그림자
        containerView.layer.shadowColor = ShadowSet.shadowColor
        containerView.layer.shadowOffset = ShadowSet.shadowOffsetStrong
        containerView.layer.shadowRadius = ShadowSet.shadowRadius
        containerView.layer.shadowOpacity = ShadowSet.shadowOpacityWeak
        containerView.layer.masksToBounds = false
        
        humidityLabel.text = "40%"
        humidityLabel.textColor = .white
        humidityLabel.font = UIFont.boldSystemFont(ofSize: 40)
        
        locationNameLabel.text = "수원시"
        locationNameLabel.textColor = .white
        locationNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        let image = UIImage(systemName: "plus")
        plusView.image = image
        plusView.backgroundColor = .clear
        plusView.layer.cornerRadius = 20
        plusView.tintColor = .systemGray4
        plusView.contentMode = .scaleAspectFit
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
        
        plusView.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(30)
        }
        
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(30)
            make.leading.equalTo(containerView).offset(20)
            make.width.equalTo(containerView).multipliedBy(0.4)
        }
        
        locationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(20)
            make.leading.equalTo(containerView).offset(20)
            make.width.equalTo(200)
        }
    }
    
    func configure(with model: ListViewCellViewModel) {
        locationNameLabel.text = model.city
        humidityLabel.text = model.humidity
    }
}
