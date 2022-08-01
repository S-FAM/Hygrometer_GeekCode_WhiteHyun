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
    var weatherModel: WeatherRequest?
    var weatherList: [WeatherResponse] = []
    
    lazy var weatherListTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.register(WeatherListTableViewCell.self, forCellReuseIdentifier: "WeatherListTableViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupLayouts()
    }
    
    
    func setModel() {
        let model = UserData.shared.items
        
    }
   
    func setupLayouts() {
        view.addSubview(weatherListTableView)
        weatherListTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        weatherListTableView.backgroundColor = .red.withAlphaComponent(0.5)
    }
    
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return weatherList.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableViewCell", for: indexPath) as! WeatherListTableViewCell
        
        

        let data = UserData.shared.items
        cell.locationNameLabel.text = "수원시"
        cell.humidityLabel.text = "50%"
        
        cell.plusView.isHidden = ( indexPath.row == weatherList.count + 1 ) ? true : false
       
        return cell
    }
    
}
