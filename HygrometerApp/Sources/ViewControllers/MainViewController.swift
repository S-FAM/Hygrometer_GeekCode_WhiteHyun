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
        $0.setViewControllers([dataViewControllers[0]], direction: .forward, animated: true)
        $0.dataSource = self
        $0.delegate = self
    }
    
    private lazy var listButton = UIButton().then {
        $0.setImage(UIImage(systemName: "list.star"), for: .normal)
        $0.tintColor = .label
        $0.addTarget(self, action: #selector(listButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var plusButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = .label
        $0.addTarget(self, action: #selector(plusButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var control = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .white
        $0.pageIndicatorTintColor = .white.withAlphaComponent(0.3)
        $0.backgroundColor = .label.withAlphaComponent(0.3)
        $0.numberOfPages = dataViewControllers.count
        $0.currentPage = 0
    }
    
    private var dataViewControllers = [UIViewController]().with { array in
        UserData.shared.items.forEach { model in
            let vc = CityViewController()
            vc.configure(with: model)
            array.append(vc)
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        setupConstraints()
        setupStyles()
    }
    
    // MARK: - Configuration
    
    /// view에 올려놓을 프로퍼티를 설정합니다. `addSubview` 메서드를 여기에 작성합니다.
    private func setupLayouts() {
        [pageViewController.view, listButton, plusButton, control].forEach { view.addSubview($0) }
    }
    
    /// 프로퍼티의 제약조건을 설정합니다.
    private func setupConstraints() {
        
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        listButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.width.height.equalTo(50)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(listButton.snp.bottom).inset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.width.height.equalTo(50)
        }
        
        control.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    /// ViewController 내에 style을 설정합니다.
    private func setupStyles() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - objc Function
    
    @objc func listButtonDidTap() {
        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func plusButtonDidTap() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource

extension MainViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
              index > 0
        else {
            return nil
        }
        return dataViewControllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
              index + 1 < dataViewControllers.count
        else {
            return nil
        }
        return dataViewControllers[index + 1]
        
    }
}

extension MainViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let vc = pageViewController.viewControllers?.first,
              let index = dataViewControllers.firstIndex(of: vc) else {
            return
        }
        control.currentPage = index
    }
}
