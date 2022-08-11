//
//  WeatherListTableViewCell.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/17.
//

import UIKit

import SnapKit
import Then
class ListTableEmptyCell: UITableViewCell {
    
    lazy var containerView = UIView().then {
        $0.backgroundColor = .themeColor.withAlphaComponent(0.5)
        $0.layer.shadowColor = ShadowSet.shadowColor
        $0.layer.shadowOffset = ShadowSet.shadowOffsetStrong
        $0.layer.shadowRadius = ShadowSet.shadowRadius
        $0.layer.shadowOpacity = ShadowSet.shadowOpacityWeak
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 20
    }
    
    lazy var plusView = UIImageView().then {
        let image = UIImage(systemName: "plus")
        $0.image = image
        $0.backgroundColor = .clear
        $0.tintColor = .systemGray4
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 20
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        setLayout()
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
}
