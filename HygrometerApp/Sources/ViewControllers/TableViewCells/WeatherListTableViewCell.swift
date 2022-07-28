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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setWeatherListTabeViewCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWeatherListTabeViewCellLayout() {
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.85)
        }
    }
}
