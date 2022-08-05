//
//  MainViewController.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/09.
//

import Combine
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
        $0.numberOfPages = dataViewControllers.count + 1
        $0.currentPage = 0
        $0.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
    }
    
    private var dataViewControllers = [UIViewController]().with { array in
        UserData.shared.items.forEach { model in
            let vc = CityViewController()
            vc.configure(with: model)
            array.append(vc)
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        setupConstraints()
        setupStyles()
        setupLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPages()
    }
    
    // MARK: - Configuration
    
    /// view에 올려놓을 프로퍼티를 설정합니다. `addSubview` 메서드를 여기에 작성합니다.
    private func setupLayouts() {
        [pageViewController.view, listButton, plusButton, control].forEach { view.addSubview($0) }
    }
    
    /// 프로퍼티의 제약조건을 설정합니다.
    private func setupConstraints() {
        
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        view.backgroundColor = .systemGray
        navigationController?.navigationBar.isHidden = true
    }
    
    /// 사용자 위치에 따른 습도 설정
    private func setupLocations() {
        
        // 1. 사용자 위치 가져옴
        LocationManager.shared.userLocation { [unowned self] location in
            
            // 2. 모델 생성
            let requestModel = CoordinateRequest(
                key: Private.gpsSecretKey,
                point: Point(x: String(location.coordinate.longitude), y: String(location.coordinate.latitude))
            )
            
            // 3. 좌표로 하여금 도시 이름 가져옴
            API.cityName(with: requestModel) { response in
                guard case let .success(data) = response else { return }
                let address = data.response.result[0].structure
                
                // 4. UserDataModel 생성
                let model = UserDataModel(id: "", city: "\(address.country) \(address.city)", point: Point(x: String(location.coordinate.longitude), y: String(location.coordinate.latitude)))
                
                // 5. 사용자의 위치로 보여주는 VC 생성
                let vc = CityViewController()
                vc.configure(with: model)
                
                // 6. View 설정
                self.dataViewControllers.insert(vc, at: 0)
                self.pageViewController.setViewControllers([vc], direction: .forward, animated: false)
                
                vc.$humidity
                    .sink {
                        self.setBackgroundImage(with: $0)
                    }
                    .store(in: &self.subscriptions)
            }
        }
    }
    
    private func setBackgroundImage(with humidity: Int) {
        guard let phraseModel = PhraseModel(humidity: humidity),
              let backgroundImage = UIImage.backgroundImage(with: phraseModel)
        else {
            return
        }
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
            self?.view.backgroundColor = .init(patternImage: backgroundImage).withAlphaComponent(0.8)
        }
    }
    
    
    private func reloadPages() {
        let models = UserData.shared.items
        control.numberOfPages = models.count + 1
        guard let vcs = dataViewControllers as? [CityViewController] else { return }
        // models의 id가 dataViewControllers의 id에 있는지 확인 후 없으면 추가
        models.forEach { model in
            guard vcs.first(where: { $0.id == model.id }) == nil else { return }
            let vc = CityViewController()
            vc.configure(with: model)
            dataViewControllers.append(vc)
        }
    }
    
    // MARK: - objc Function
    
    @objc private func listButtonDidTap() {
        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func plusButtonDidTap() {
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
        
        guard let vc = pageViewController.viewControllers?.first as? CityViewController,
              let index = dataViewControllers.firstIndex(of: vc) else {
            return
        }
        control.currentPage = index
        
        setBackgroundImage(with: vc.humidity)
    }
}
