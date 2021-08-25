//
//  WeatherModel.swift
//  basic_weather
//
//  Created by Đại Nguyễn  on 8/19/21.
//

import Foundation

struct WeatherInfo {
    var id: Int = 0
    var name: String = ""
    var main: WeatherMain?
    var weather: WeatherDes?
    var dt: String = ""
}

struct WeatherDes {
    var main: String?
    var des: String?

    mutating func initLoad(_ json:  [String: Any]) -> WeatherDes {
       if let temp = json["main"] as? String { main = temp }
       if let temp = json["description"] as? String { des = temp }
    
       return self
   }
}

struct WeatherMain {
    var temp: Double?
    var temp_min: Double?
    var temp_max: Double?
    var feels_like: Double?
    var pressure: Double?
    
    mutating func initLoad(_ json:  [String: Any]) -> WeatherMain {
        if let temp = json["temp"] as? Double { self.temp = temp }
        if let temp = json["temp_min"] as? Double { temp_min = temp }
        if let temp = json["temp_max"] as? Double { temp_max = temp }
        if let temp = json["feels_like"] as? Double { feels_like = temp }
        if let temp = json["pressure"] as? Double { pressure = temp }
        return self
    }
}
