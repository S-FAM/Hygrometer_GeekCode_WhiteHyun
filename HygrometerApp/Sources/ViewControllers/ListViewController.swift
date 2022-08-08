//
//  ListViewController.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/09.
//
import SnapKit
import UIKit

class ListViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel = ListViewModel()

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
        viewModel.setup() { [weak self] in
            self?.weatherListTableView.reloadData()
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
        return UserData.shared.items.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let isLastCell = indexPath.row == viewModel.models.count
        
        switch isLastCell {
            
        case true:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableEmptyCell", for: indexPath) as! ListTableEmptyCell
            return cell
            
        case false:
            
            let model = viewModel.models[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableViewCell", for: indexPath) as! WeatherListTableViewCell
            cell.configure(with: model)
            
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let isLastCell = indexPath.row == UserData.shared.items.count
        
        switch isLastCell {
            
        case true:
            
            let vc = AddViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case false:
            
            let alertVC = UIAlertController(title: "", message: "삭제하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let confirm = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                UserData.shared.items.remove(at: indexPath.row )
                self?.weatherListTableView.reloadData()
            }
            [ cancel, confirm ].forEach { alertVC.addAction($0) }
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
