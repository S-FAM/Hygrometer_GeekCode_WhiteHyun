//
//  AddViewController.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/09.
//

import UIKit
import Alamofire

class AddViewController: UIViewController {
    
    var weatherModel: WeatherModel?
    var searchGpsModel: [Item]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemTeal
        
        getGpsApi(searchStr: "수원") { result in
            self.searchGpsModel = result
            print("searchGpsModel: ",self.searchGpsModel)
            
//            self.CustomTableView.reloadData()

        }


    }
    
    /// GPS API를 조회하는 함수
    /// - Parameters:
    ///   - searchStr: 검색값
    ///   - completionHandler: 모델에 결과값 저장
    func getGpsApi( searchStr: String, completionHandler: @escaping ([Item]) -> Void ) {
//        let urlString = API.makeString(With: [ApiType.gps.host,"key=\(Private.gpsSecretKey)&query=\(searchStr)&request=search&type=district&category=L4"])
        
        let urlStr = API.makeString(With: [ApiType.gps.host])
        
        let parameters = GpsParamModel(
          key: Private.gpsSecretKey,
          query: searchStr,
          request: "search",
          type: "district",
          category: "L4"
        )
        
//        print(urlStr)
        getWeatherData(lat: "126.991288889", long: "37.3022000002")
        
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
        let urlStr = API.makeString(With: [ApiType.weather.host])
        
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
    //        let main =
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
