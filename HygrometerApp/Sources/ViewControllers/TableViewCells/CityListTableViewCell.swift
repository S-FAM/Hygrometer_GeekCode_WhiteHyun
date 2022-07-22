//
//  CityListTableViewCell.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/17.
//

import UIKit

class CityListTableViewCell: UITableViewCell {

    let containerView = UIView()
    let locationNameLabel = UILabel()
    let nationNameLabel = UILabel()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCityListTabeViewCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCityListTabeViewCellLayout(){
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
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
        
        
        
        containerView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.4)
            make.leading.equalTo(self).offset(self.frame.width * 0.07)
        }
        locationNameLabel.text = "수원시"
        locationNameLabel.textColor = UIColor.lightGray
        locationNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        locationNameLabel.textAlignment = .left
        locationNameLabel.adjustsFontSizeToFitWidth = true

        
        containerView.addSubview(nationNameLabel)
        nationNameLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self).inset(30)
            make.centerY.equalTo(locationNameLabel)
            make.height.equalTo(self).multipliedBy(0.25)
        }
        nationNameLabel.text = "대한민국"
        nationNameLabel.textColor = UIColor.black
        nationNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nationNameLabel.textAlignment = .left
        nationNameLabel.adjustsFontSizeToFitWidth = true
    }

}
