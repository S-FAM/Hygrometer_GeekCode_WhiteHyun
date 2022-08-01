//
//  TestViewModel.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/28.
//

import Foundation


class ListViewModel {
    var models: [ListViewCellViewModel]
    
    init() {
        models = []
        for _ in 0..<UserData.shared.items.count {
            models.append(ListViewCellViewModel(city: "", humidity: ""))
        }
    }
    
    // 비동기 동작
    func setup(completion: @escaping () -> Void) {
        
        UserData.shared.items.forEach { [weak self] model in
            
            let x = model.point.x
            let y = model.point.y
            
            let requestModel = WeatherRequest(
                lat: y,
                lon: x,
                appID: Private.weatherSecretKey,
                lang: "ko"
            )
            
            API.weatherInformation(with: requestModel) { response in
                
                guard case let .success(result) = response else {
                    return
                }
                let tempModel = ListViewCellViewModel(
                    city: model.city,
                    humidity: "\(result.main.humidity)%"
                )
                self?.models.append(tempModel)
                
                if self?.models.count == (UserData.shared.items.count << 1) {
                    self?.models.removeFirst(UserData.shared.items.count)
                    print("Completion!")
                    completion()
                }
            }
        }
    }
}
