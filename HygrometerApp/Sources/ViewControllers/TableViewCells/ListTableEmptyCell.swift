//
//  WeatherListTableViewCell.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/17.
//

import UIKit

class ListTableEmptyCell: UITableViewCell {
    
    let containerView = UIView()
    let plusView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setLayout()
        setDetail()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        
        contentView.addSubview(containerView)
        containerView.addSubview(plusView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        
        plusView.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(30)
        }
    }
    
    func setDetail() {
        
        backgroundColor = .clear
        selectionStyle = .none
        containerView.backgroundColor = .themeColor
        containerView.layer.cornerRadius = 20
        //그림자
        containerView.layer.shadowColor = ShadowSet.shadowColor
        containerView.layer.shadowOffset = ShadowSet.shadowOffsetStrong
        containerView.layer.shadowRadius = ShadowSet.shadowRadius
        containerView.layer.shadowOpacity = ShadowSet.shadowOpacityWeak
        containerView.layer.masksToBounds = false

        
        let image = UIImage(systemName: "plus")
        plusView.image = image
        plusView.backgroundColor = .clear
        plusView.layer.cornerRadius = 20
        plusView.tintColor = .systemGray4
        plusView.contentMode = .scaleAspectFit
    }
    
}
