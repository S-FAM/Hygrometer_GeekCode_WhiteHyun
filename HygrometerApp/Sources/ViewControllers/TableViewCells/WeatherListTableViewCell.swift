//
//  WeatherListTableViewCell.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/17.
//

import UIKit

class WeatherListTableViewCell: UITableViewCell {
    
    let humidityLabel = UILabel()
    let locationNameLabel = UILabel()
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
        setBackground(isDark: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDetail(){
        backgroundColor = .clear
        selectionStyle = .none

        humidityLabel.font = UIFont.boldSystemFont(ofSize: 40)
        locationNameLabel.font = UIFont.boldSystemFont(ofSize: 15)

        [ humidityLabel, locationNameLabel ].forEach {
            $0.text = ""
            $0.textColor  = .white
        }
        
    }
    
    func setLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(cellImageView)
        cellImageView.addSubview(locationNameLabel)
        cellImageView.addSubview(humidityLabel)
        
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
    }
    func setBackground(isDark: Bool) {
        
        let imageName = isDark ? "HygrometerCellDark" : "HygrometerCellLight"
        cellImageView.image = UIImage(named: imageName)
        
    }
    
    func configure(with model: ListViewCellViewModel) {
        locationNameLabel.text = model.city
        humidityLabel.text = model.humidity
    }
}
