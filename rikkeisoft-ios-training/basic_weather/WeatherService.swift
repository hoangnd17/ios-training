//
//  WeatherService.swift
//  basic_weather
//
//  Created by Đại Nguyễn  on 8/19/21.
//

import Foundation

class WeatherService {
    static let shared: WeatherService = WeatherService()
    
    func fetchData(url: String, completion: @escaping ([String:Any]?, Error?) -> Void) {
        let url = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    completion(array, nil)
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func getInfo(url: String,closure: @escaping (_ response: WeatherInfo?, _ error: Error?) -> Void) {
        
        fetchData(url: url) { (data, error) in
            if let d = data {
                var weatherInfo = WeatherInfo()
                if let id = d["id"] as? Int {
                    weatherInfo.id = id
                }
                if let name = d["name"] as? String {
                    weatherInfo.name = name
                }
                
                if let main = d["main"] as? [String : Any] {
                    var weatherMain:WeatherMain = WeatherMain()
                    weatherInfo.main = weatherMain.initLoad(main)
                }
                
                if let weather = d["weather"] as? [[String : Any]] {
                    var weatherDes: WeatherDes = WeatherDes()
                    weatherInfo.weather = weatherDes.initLoad(weather[0])
                }
                closure(weatherInfo, nil)
            }
            else {closure(nil,nil)}
        }
    }
    
    
    func getHourlyInfo(url: String, closure: @escaping (_ response: [WeatherInfo]?, _ error: Error?) -> Void) {
        fetchData(url: url) { (data, error) in
            guard let data = data,
                  let list = data["list"] as? [[String : Any]]
            else {
                closure(nil,error)
                return
            }
            
            var listReturn: [WeatherInfo] = [WeatherInfo]()
            for hourlyInfo in list {
                var weatherInfo = WeatherInfo()
                
                if let main = hourlyInfo["main"] as? [String : Any] {
                    var weatherMain:WeatherMain = WeatherMain()
                    weatherInfo.main = weatherMain.initLoad(main)
                }
                
                if let weather = hourlyInfo["weather"] as? [[String : Any]] {
                    var weatherDes: WeatherDes = WeatherDes()
                    weatherInfo.weather = weatherDes.initLoad(weather[0])
                }
                
                if let dt = hourlyInfo["dt_txt"] as? String {
                    weatherInfo.dt = dt
                }
                
                listReturn.append(weatherInfo)
            }

            closure(listReturn,nil)
        }
        
    }
}

