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
    let NationNameLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCityListTabeViewCellLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
    
    
    func setCityListTabeViewCellLayout(){
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.leading.bottom.equalTo(self)
            
        }
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        
        
        containerView.addSubview(locationNameLabel)
        
        locationNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.4)
            make.leading.equalTo(self).offset(self.frame.width * 0.05)
        }
        locationNameLabel.text = "수원시"
        locationNameLabel.textColor = UIColor.lightGray
        locationNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        locationNameLabel.textAlignment = .left
        locationNameLabel.adjustsFontSizeToFitWidth = true

        
        containerView.addSubview(NationNameLabel)
        NationNameLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self).inset(30)
            make.centerY.equalTo(locationNameLabel)
            make.height.equalTo(self).multipliedBy(0.25)
        }
        NationNameLabel.text = "대한민국"
        NationNameLabel.textColor = UIColor.black
        NationNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        NationNameLabel.textAlignment = .left
        NationNameLabel.adjustsFontSizeToFitWidth = true
        
    }

}
