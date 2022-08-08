//
//  ListViewController.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/09.
//
import SnapKit
import UIKit
import Combine

class ListViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel = ListViewModel()
    var subscriptions = Set<AnyCancellable>()

    lazy var weatherListTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.register(WeatherListTableViewCell.self, forCellReuseIdentifier: "WeatherListTableViewCell")
        $0.register(ListTableEmptyCell.self, forCellReuseIdentifier: "ListTableEmptyCell")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemCyan
        setupLayouts()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.setup().sink { [weak self] _ in
            self?.weatherListTableView.reloadData()
        } receiveValue: { [weak self] value in
            self?.viewModel.models.removeAll()
            
           let value =  value.enumerated().map {
                ListViewCellViewModel(city: UserData.shared.items[$0].city, humidity: "\($1.main.humidity)%")
            }
            
            self?.viewModel.models.append(contentsOf: value)
            
        }.store(in: &subscriptions)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        subscriptions.map { subscription in
            subscription.cancel()
        }
    }
       
    // MARK: - Configuration
    
    private func setupLayouts() {
        self.view.addSubview(weatherListTableView)
    }
    
    private func setupConstraints() {
        weatherListTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = section == 0 ? UserData.shared.items.count : 1
        return count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        switch indexPath.section {
            
        case 0:
            
            let model = viewModel.models[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableViewCell", for: indexPath) as! WeatherListTableViewCell
            cell.configure(with: model)

            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableEmptyCell", for: indexPath) as! ListTableEmptyCell
            return cell
            
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            
            let alertVC = UIAlertController(title: "", message: "삭제하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let confirm = UIAlertAction(title: "확인", style: .default) { [weak self] UIAlertAction in
                UserData.shared.items.remove(at: indexPath.row)
                self?.viewModel.models.remove(at: indexPath.row)
                self?.weatherListTableView.reloadData()
            }
            
            [ cancel, confirm ].forEach { alertVC.addAction($0) }
            self.present(alertVC, animated: true, completion: nil)
            
        case 1:
            
            let vc = AddViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            fatalError()
        }
    }
}
