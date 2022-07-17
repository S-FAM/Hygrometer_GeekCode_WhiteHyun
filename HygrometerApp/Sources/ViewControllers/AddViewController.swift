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
    
    var weatherModel: WeatherModel?
    var searchGpsModel: [Item] = []
    var cityList: [Item] = []
    var searchCityList: [Item] = []
    var searchString = ""
    
    
    let cityListSearchBar = UISearchBar()
    let cityListTableView = UITableView()
    
    let emptyResultLabel = UILabel() // 테이블뷰 조회결과가 없는 경우
    let emptyResultView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        setLayout()
        self.view.backgroundColor = .themeColor.withAlphaComponent(0.7)
        


    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchString = "남원"
        getGpsApi(searchStr: searchString) { result in
            if let parsedArray = result as? [Item]  {
                self.cityList = parsedArray
                self.searchCityList = self.cityList
                print("cityList: ",self.searchCityList)
            }
            
        }
    }
    
    func setLayout(){
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(cityListSearchBar)
        cityListSearchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(self.view.frame.height * 0.01)//offset
            make.width.equalTo(self.view).multipliedBy(0.95)
            make.height.equalTo(self.view).multipliedBy(0.05)
            make.centerX.equalTo(self.view)
        }
        //TODO: - 서치바 dÔelegate
        cityListSearchBar.delegate = self
        cityListSearchBar.placeholder = "Search for city"
        cityListSearchBar.searchBarStyle = .minimal
        cityListSearchBar.tintColor = .systemYellow
        cityListSearchBar.setImage(UIImage(named: "icCancel"), for: .clear, state: .normal)
        cityListSearchBar.setImage(UIImage(named: "icSearchNonW"), for: UISearchBar.Icon.search, state: .normal)
        if let textfield = cityListSearchBar.value(forKey: "searchField") as? UITextField {
            //서치바 백그라운드 컬러
            textfield.backgroundColor = .themeColor
            //플레이스홀더 글씨 색 정하기
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            //서치바 텍스트입력시 색 정하기
            textfield.textColor = .white
            //왼쪽 아이콘 이미지넣기
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                //이미지 틴트컬러 정하기
                leftView.tintColor = .lightGray
            }
            //오른쪽 x버튼 이미지넣기
            if let rightView = textfield.rightView as? UIImageView {
                rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
                //이미지 틴트 정하기
                rightView.tintColor = .lightGray
            }
            
            self.view.addSubview(emptyResultView)
            emptyResultView.snp.makeConstraints { make in
                make.top.equalTo(cityListSearchBar.snp.bottom).offset(self.view.frame.height * 0.01)
                make.leading.trailing.equalTo(cityListSearchBar)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
                make.centerX.equalTo(self.view)

            }
            emptyResultView.backgroundColor = .themeColor
            emptyResultView.layer.cornerRadius = 20
            //그림자
            emptyResultView.layer.shadowColor = ShadowSet.shadowColor
            emptyResultView.layer.shadowOffset = ShadowSet.shadowOffsetWeak
            emptyResultView.layer.shadowRadius = ShadowSet.shadowRadius
            emptyResultView.layer.shadowOpacity = ShadowSet.shadowOpacityWeak
            emptyResultView.layer.masksToBounds = false

            self.emptyResultView.addSubview(emptyResultLabel)
            emptyResultLabel.snp.makeConstraints { make in
                make.top.equalTo(emptyResultView).offset(20)
                make.centerX.equalTo(emptyResultView)
                make.width.height.equalTo(emptyResultView).multipliedBy(0.5)

            }
            emptyResultLabel.text = "검색 결과가 없습니다"
            emptyResultLabel.textColor = .lightGray
            emptyResultLabel.textAlignment = .center
            
            self.view.addSubview(cityListTableView)
            cityListTableView.snp.makeConstraints { make in
                make.top.bottom.leading.trailing.equalTo(emptyResultView)
            }
            cityListTableView.backgroundColor = .themeColor
            cityListTableView.layer.cornerRadius = 20

            cityListTableView.dataSource = self
            cityListTableView.delegate = self
            cityListTableView.keyboardDismissMode = .onDrag


            let sharedNib = UINib(nibName: "CityListTableViewCell", bundle: nil)
            self.cityListTableView.register(sharedNib, forCellReuseIdentifier: "CityListTableViewCell")
            
            
        }

        

    }
    /// GPS API를 조회하는 함수
    /// - Parameters:
    ///   - searchStr: 검색값
    ///   - completionHandler: 모델에 결과값 저장
    func getGpsApi( searchStr: String, completionHandler: @escaping ([Item]) -> Void ) {
//        let urlString = API.makeString(With: [ApiType.gps.host,"key=\(Private.gpsSecretKey)&query=\(searchStr)&request=search&type=district&category=L4"])
        
        let urlStr = API.makeString(with: [ApiType.gps.host])
        
        let parameters = GpsParamModel(
          key: Private.gpsSecretKey,
          query: searchStr,
          request: "search",
          type: "district",
          category: "L4"
        )
        
//        print(urlStr)
//        getWeatherData(lat: "126.991288889", long: "37.3022000002")
        
        AF
          .request(urlStr, method: .get, parameters: parameters)
          .responseDecodable(of: GpsModel.self) { response in
            switch response.result {
            case .success(let result):
              completionHandler(result.response.result.items)
            case .failure(let error):
              print(error)
            }
          }
          .resume()
        
    }
    
    
    func getWeatherData(lat: String, long: String){
        
//        let lat = "37"
//        let long = "-122.40"
//        let address = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(serviceKey)"
        let address = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=93d5e000c78231dfa9d072fe49692c9d&lang=kr"
        let urlStr = API.makeString(with: [ApiType.weather.host])
        
        print("urlStr : \(urlStr)")
        
//        let parameters = WeatherParamModel(
//          lat: lat,
//          long: long,
//          appid: Private.weatherSecretKey,
//          lang: "kr"
//        )
        
        API.getDataReturnData(url: address) { resultData in
            
            guard let data = resultData else { return }
            
            self.getJsonDecoder(data: data)
            
            getWeatherIconName() // 수정필요
            
        } errorHandler: { error in
            print("WeatherList return data error ::: \(error.localizedDescription)")

        }

        
        
        /// openWeather Main 값에 따라 String 반환
        /// - Returns: Lottie Weater
        func getWeatherIconName() -> String{
            guard let data = self.weatherModel else { return ""}
            
            print("data: \(data.weather[0].main)")
    //        let main = self.weatherModel.main
    //        print("main: \(main)")
            switch data.weather[0].main {
            case "Clouds":
                return "weatherWindy"
            case "Clear":
                return "weatherSunny"
            case "Rain":
                return "weatherPartlyShower"
            case "Atmospher":
                return "weatherFoggy"

            default:
                return "weatherSnow"
            }
        }
        

    }

    
    func getJsonDecoder(data: Data) {

            do {
                let jsonDecoder = try JSONDecoder().decode(WeatherModel.self, from: data)
                self.weatherModel = jsonDecoder
                DispatchQueue.main.async {
//                    print("weather: ", self.weatherModel?.weather)
                    print("weather: ", self.weatherModel)

//                    self.setWeatherAnimation()
                    
                }
            } catch {
                print("EquipmentList jsonDecoder fail error ::: \(error)")
            }
        
    }
    
}


extension AddViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        self.searchString = searchText
        self.searchCityList = self.cityList.filter({$0.title.lowercased().contains(searchText.lowercased())})
            if searchText == "" {
                self.searchCityList = cityList
            }
            self.cityListTableView.reloadData()
            
            // 값이 없는 경우
            DispatchQueue.main.async {
                self.cityListTableView.isHidden = (self.searchCityList.count == 0) ? true : false
            }

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

            cell.locationNameLabel.text = "\(self.searchCityList[indexPath.row].title)"
            cell.NationNameLabel.text = "대한민국"
   
        cell.backgroundColor = .clear
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let currentPoint = searchCityList[indexPath.row].point
        print("currentPoint: \(currentPoint)")

    }
}
