//
//  ViewController.swift
//  basic_weather
//
//  Created by Đại Nguyễn  on 8/19/21.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let todayUrl = "https://api.openweathermap.org/data/2.5/weather?id=1581129&appid=5fa5336f3c4000e23f503e7a135d1860&units=metric&lang=vi"
    
    let hourlyUrl = "https://api.openweathermap.org/data/2.5/forecast?id=1581129&appid=5fa5336f3c4000e23f503e7a135d1860&units=metric&lang=vi"
    
    var todayRes = WeatherInfo()
    var hourlyRes: [WeatherInfo] = [WeatherInfo]()
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var dess: UILabel!
    @IBOutlet weak var hourlyTb: UICollectionView!
    @IBOutlet weak var minMax: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getInfo { _,_ in
        }
        
        self.getInfoHourly { _, _ in
        }
        
        
        // register cell
        hourlyTb.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        
        hourlyTb.delegate = self
        hourlyTb.dataSource = self
    }
    
    // Hàm lấy dữ liệu
    func getInfo(andCompletion completion:@escaping (_ response: WeatherInfo, _ error: Error?) -> ()) {
        
        WeatherService.shared.getInfo(url: todayUrl) { [weak self] (data, error) in
            guard let strongSelf = self else {
                return
            }
            if let data = data {
                strongSelf.todayRes = data
                DispatchQueue.main.async {
                    strongSelf.config(with: strongSelf.todayRes)
                }
            }
            completion(strongSelf.todayRes, error)
        }
    }
    
    func getInfoHourly(andCompletion completion:@escaping (_ response: [WeatherInfo], _ error: Error?) -> ()) {
        
        WeatherService.shared.getHourlyInfo(url: hourlyUrl) {[weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            if let data = response {
                strongSelf.hourlyRes.removeAll()
                strongSelf.hourlyRes = data
                DispatchQueue.main.async {
                    strongSelf.hourlyTb.reloadData()                }
            }
            completion(strongSelf.hourlyRes, error)
        }
    }
    
    func config(with model: WeatherInfo) {
        guard let name = model.name as? String,
              let main = model.main,
              let weather = model.weather,
              let temp = main.temp,
              let des = weather.des,
              let feels_like = main.feels_like,
              let min = main.temp_min,
              let max = main.temp_max
        else {
            return
        }
        self.name.text = name
        self.temp.text = "\(String(describing: temp))°C"
        dess.text = "Nhiệt độ cảm nhận: \(String(describing: feels_like))°C\n\(String(describing: des))"
        minMax.text = "\(String(describing: max))/\(String(describing: min))"
    }
    
}



extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyRes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = hourlyRes[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as! HourlyCollectionViewCell
        cell.temp.text = String(model.main?.temp ?? 0)
        cell.time.text = model.dt
        return cell
        
    }
    
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (view.frame.width / 4 ), height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
