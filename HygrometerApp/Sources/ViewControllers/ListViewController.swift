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
        $0.register(CityListTableViewCell.self, forCellReuseIdentifier: "CityListTableViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemTeal
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weatherList.count + 1
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableViewCell", for: indexPath) as! WeatherListTableViewCell
        
        cell.locationNameLabel.text = ""
        cell.humidityLabel.text = ""
        
        cell.plusView.isHidden = ( indexPath.row == weatherList.count + 1 ) ? true : false
            
       
        return cell
    }
    
}
