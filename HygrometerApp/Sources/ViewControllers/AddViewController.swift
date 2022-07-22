//
//  AddViewController.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/09.
//

import UIKit
import Alamofire
import SnapKit

class AddViewController: UIViewController {
    
    // MARK: - Properties
    
    var weatherModel: WeatherResponse?
    var searchCityList: [Item] = []
    var searchString = ""
    
    lazy var cityListSearchBar = UISearchBar().then {
        $0.searchTextField.delegate = self
        $0.placeholder = "Search for city"
        $0.searchBarStyle = .minimal
        $0.tintColor = .systemYellow
        $0.setImage(UIImage(named: "icCancel"), for: .clear, state: .normal)
        $0.setImage(UIImage(named: "icSearchNonW"), for: .search, state: .normal)
    }
    
    lazy var cityListTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.keyboardDismissMode = .onDrag
        $0.dataSource = self
        $0.delegate = self
        $0.register(CityListTableViewCell.self, forCellReuseIdentifier: "CityListTableViewCell")
    }
    
    // 테이블뷰 조회결과가 없는 경우 보여짐
    let emptyResultLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다"
        $0.textColor = .lightGray
        $0.textAlignment = .center
    }
    
    let emptyResultView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 20
        $0.layer.shadowColor = ShadowSet.shadowColor
        $0.layer.shadowOffset = ShadowSet.shadowOffsetWeak
        $0.layer.shadowRadius = ShadowSet.shadowRadius
        $0.layer.shadowOpacity = ShadowSet.shadowOpacityWeak
        $0.layer.masksToBounds = false
    }
    
    /// 키보드 생성시 dismiss를 사용하기 위해 사용할 View
    lazy var tempView = UIView().then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        $0.addGestureRecognizer(tap)
        $0.backgroundColor = .red.withAlphaComponent(0.3)
        $0.isHidden = true
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()

    }
        
    @objc func keyboardWillShow(_ notification: Notification){
        print(#function)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// 검색어를 통해 GPS검색하는 함수
    /// - Parameter searchStr: 서치바의 검색어
    func searchLocation(searchStr: String){
        getGpsApi(searchStr: searchStr) { result in
            if let parsedArray = result as? [Item]  {
                self.cityList = parsedArray
                self.searchCityList = self.cityList
                self.cityListTableView.reloadData()

            }
        }
    }
    
    /// 최초 화면 터치시 cityListSearchBar 활성화
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cityListSearchBar.resignFirstResponder()
    }
    
    
    func setLayout(){
        self.view.backgroundColor = .themeColor.withAlphaComponent(0.7)
        self.view.addSubview(cityListSearchBar)
        self.view.addSubview(emptyResultView)
        self.view.addSubview(cityListTableView)
        self.view.addSubview(tempView)
        emptyResultView.addSubview(emptyResultLabel)
        
        
        cityListSearchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.width.equalTo(self.view).multipliedBy(0.95)
            make.height.equalTo(self.view).multipliedBy(0.05)
            make.centerX.equalTo(self.view)
        }
        
        emptyResultView.snp.makeConstraints { make in
            make.top.equalTo(cityListSearchBar.snp.bottom).offset(self.view.frame.height * 0.01)
            make.leading.trailing.equalTo(cityListSearchBar)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalTo(self.view)
            
        }
        
        emptyResultLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyResultView).offset(20)
            make.centerX.equalTo(emptyResultView)
            make.width.height.equalTo(emptyResultView).multipliedBy(0.5)
        }
        
        cityListTableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(emptyResultView)
        }
        
        tempView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    func setStyles() {
        
        guard let textfield = cityListSearchBar.value(forKey: "searchField") as? UITextField else { return }
        
        textfield.backgroundColor = .themeColor
        textfield.textColor = .white
        
        //왼쪽 아이콘 이미지넣기
        if let leftView = textfield.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = .lightGray
        }
        
        //오른쪽 x버튼 이미지넣기
        if let rightView = textfield.rightView as? UIImageView {
            rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
        }
    }
}


extension AddViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
//        self.searchString = searchText
        self.searchCityList = self.cityList.filter({$0.city.lowercased().contains(searchText.lowercased())})
            if searchText == "" { // 검색어가 다 지워졌을 때 전체 리스트를 보여줌
                self.searchCityList = cityList
                self.cityListTableView.reloadData()
            }
            
 

    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        guard let inputStr = searchBar.text else {return false}
        
//        self.searchString = inputStr
        self.searchLocation(searchStr: inputStr)
        return true
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AddViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.searchCityList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CityListTableViewCell", for: indexPath) as! CityListTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.locationNameLabel.text = "\(self.searchCityList[indexPath.row].city)"
            cell.nationNameLabel.text = "대한민국"
   
        
        // 값이 없는경우
        DispatchQueue.main.async {
            self.emptyResultView.isHidden = self.searchCityList.count == 0 ? false : true
            self.emptyResultLabel.isHidden = self.searchCityList.count == 0 ? false : true
            self.cityListTableView.isHidden = self.searchCityList.count == 0 ? true : false
        }
      
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentPoint = searchCityList[indexPath.row].point
        print("currentPoint: \(currentPoint)")

    }
}
