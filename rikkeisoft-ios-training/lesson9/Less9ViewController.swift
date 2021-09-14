//
//  ViewController.swift
//  lesson9
//
//  Created by Đại Nguyễn  on 8/12/21.
//

import UIKit
import UserNotifications

class Less9ViewController: UIViewController {
    
    @IBOutlet weak var timeLb: UILabel!
    
    @IBOutlet weak var timePicker: UIPickerView!

    var pickerData: [Int] = [Int]()

    var timer: Timer?
    var totalTime: Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        pickerData = Array(1...60)
        timePicker.selectRow(9, inComponent: 0, animated: true)
        pickerView(self.timePicker, didSelectRow: 9, inComponent: 0)

    }
    
    @IBAction func start(_ sender: Any) {
        self.timer?.invalidate()

        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

    }
    
    @objc func updateTimer() {
        print(self.totalTime)
        let manager = LocalNotificationManager()

        self.timeLb.text = self.timeFormatted(self.totalTime)
        if totalTime != 0 {
            totalTime -= 1
            if totalTime % 300 == 0 && totalTime != 0 {
                
                manager.notifications = [
                    Notification(id: "noti", title: "Còn \(totalTime/60) phút")
                ]
                
                manager.schedule()
            }
        } else {
            if let timer = self.timer {
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["noti"])

                // push noti
                manager.notifications = [
                    Notification(id: "end", title: "Wake up bro")
                ]
                
                manager.schedule()
                
                timer.invalidate()
                self.timer = nil
                
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
}

extension Less9ViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeLb.text = timeFormatted(pickerData[row] * 60)
        totalTime = pickerData[row] * 60
        self.timer?.invalidate()

    }
}


struct Notification {
    var id:String
    var title:String
}


class LocalNotificationManager
{
    var notifications = [Notification]()
    
 
    func listScheduledNotifications()
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

            for notification in notifications {
                print(notification)
            }
        }
    }
    
    private func requestAuthorization()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
        
        
    }
    
    func schedule()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }

    }
    
    private func scheduleNotifications()
    {
        for notification in notifications
        {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.sound    = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! ID = \(notification.id)")
            }
        }
    }
}
