//
//  TestViewModel.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/28.
//

import Foundation
import Combine
import Alamofire


class ListViewModel {
    var models: [ListViewCellViewModel]
    
    init() {
        models = []
        for _ in 0..<UserData.shared.items.count {
            models.append(ListViewCellViewModel(city: "", humidity: "", main: ""))
        }
    }
    
    // 비동기 동작
    func setup() -> AnyPublisher<[WeatherResponse], AFError> {
        
      UserData.shared.items.publisher
        .map {
          WeatherRequest(
            lat: $0.point.y,
            lon: $0.point.x,
            appID: Private.weatherSecretKey,
            lang: "ko"
          )
        }
        .flatMap(API.weatherInformationPublisher(with:))
        .eraseToAnyPublisher()
        .collect()
        .eraseToAnyPublisher()
    }
}
