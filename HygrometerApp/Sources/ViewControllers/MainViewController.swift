//
//  MainViewController.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/09.
//

import UIKit

import SnapKit
import Then

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 지역별 습도를 보여주는 VC를 갖고있는 pageViewController 입니다.
    /// 양옆으로 스와이프하여 `viewController`이동이 가능하도록 설계되었습니다.
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    ).then {
        $0.setViewControllers([CityViewController()], direction: .forward, animated: true)
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        setupConstraints()
    }
    
    // MARK: - Configuration
    
    
    /// view에 올려놓을 프로퍼티를 설정합니다. `addSubview` 메서드를 여기에 작성합니다.
    private func setupLayouts() {
        view.addSubview(pageViewController.view)
    }
    
    
    /// 프로퍼티의 제약조건을 설정합니다.
    private func setupConstraints() {
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
