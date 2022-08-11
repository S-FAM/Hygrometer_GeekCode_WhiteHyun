//
//  AddViewController.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/09.
//

import UIKit
import Combine
import Alamofire
import SnapKit

class AddViewController: UIViewController {
    
    // MARK: - Properties
    var searchCityList: [Item] = []
    var searchString = ""
    var keyboardMonitor: KeyboardMonitor?
    var subscriptions = Set<AnyCancellable>()
    var isTempPage = false
    
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
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setStyles()
        keyboardMonitor = KeyboardMonitor()
        observingKeyboardEvent()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// 검색어를 통해 GPS검색하는 함수
    /// - Parameter searchStr: 서치바의 검색어
    private func searchLocation(searchStr: String) {
        
        let model = GpsRequest(
            key: Private.gpsSecretKey,
            query: searchStr,
            request: "search",
            type: "district",
            category: "L4"
        )
        
        API.cityInformation(with: model) { response in
            switch response {
            case .success(let data):
                let parsedArray = data.response.result.items
                self.searchCityList = parsedArray
                DispatchQueue.main.async { [weak self] in
                    self?.cityListTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// 최초 화면 터치시 cityListSearchBar 활성화
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cityListSearchBar.resignFirstResponder()
    }
    
    /// setTempView를 터치할 때 실행되는 함수
    @objc private func hideKeyboard() {
        print("화면Tap감지")
        
        guard let inputStr = cityListSearchBar.searchTextField.text else { return }
        print("inputStr: ",inputStr)
        cityListSearchBar.resignFirstResponder()
        searchLocation(searchStr: inputStr)
    }
    

}

// MARK: - Layouts

extension AddViewController {
    
    private func setLayout() {
        self.view.backgroundColor = .black
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
    
    private func setStyles() {
        
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


extension AddViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let inputStr = textField.text else { return false }
        
        cityListSearchBar.resignFirstResponder()
        searchLocation(searchStr: inputStr)
        
        return true
    }
}

// MARK: - UITableViewDelegate
extension AddViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let point = searchCityList[indexPath.row].point
        let city = searchCityList[indexPath.row].city
        let id = searchCityList[indexPath.row].id
        
        let model = UserDataModel(id: id, city: city, point: point)
        UserData.shared.items.append(model)
        
        if isTempPage {
            self.isTempPage = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: "resetAnimation"), object: nil, userInfo: nil)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension AddViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityListTableViewCell", for: indexPath) as! CityListTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.locationNameLabel.text = "\(searchCityList[indexPath.row].city)"
        cell.nationNameLabel.text = "대한민국"
        
        // 값이 없는경우
        DispatchQueue.main.async {
            self.emptyResultView.isHidden = self.searchCityList.count == 0 ? false : true
            self.emptyResultLabel.isHidden = self.searchCityList.count == 0 ? false : true
            self.cityListTableView.isHidden = self.searchCityList.count == 0 ? true : false
        }
        return cell
    }
}

//MARK: - KeyboardMonitor
extension AddViewController {
    
    ///키보드 height를 받아서 처리
    private func observingKeyboardEvent() {
        keyboardMonitor?.$status.sink { [weak self] mode in

        //키보드의 높이가 변할때 tempView를 띄워서 상단 터치시 dismiss처리
        self?.tempView.isHidden = mode == KeyboardMonitor.Status.show ? false : true

        }.store(in: &subscriptions)
    }
    

}


//extension AddViewController : animationProtocol {
////    func resetAnimation() {
////        <#code#>
////    }
////
//
//
//}
