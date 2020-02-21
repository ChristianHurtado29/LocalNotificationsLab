//
//  CreatingVC.swift
//  LocalNotificationsLab
//
//  Created by Christian Hurtado on 2/20/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit

protocol CreatingVCDelegate: AnyObject {
    func didCreateNotification(_ createNotificationCenter: CreatingVC)
}

class CreatingVC: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var hourPickerView: UIPickerView!
    @IBOutlet weak var minPickerView: UIPickerView!
    @IBOutlet weak var secPickerView: UIPickerView!
    
    weak var delegate: CreatingVCDelegate?
    
    var hoursTime = Int() {
        didSet {
         
        }
    }
    lazy var minutesTime = Int()

    
    lazy var secondsTime = Int()
    
    var timeInterval: TimeInterval = Double(5.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        hourPickerView.delegate = self
        minPickerView.delegate = self
        secPickerView.delegate = self
        hourPickerView.dataSource = self
        minPickerView.dataSource = self
        secPickerView.dataSource = self
    }
    
    private func createLocalNotification(){
        let content = UNMutableNotificationContent()
        content.title = titleTextField.text ?? "No title"
        content.body = "local notifications is awesome when used appropriately"
        content.subtitle = "learning local notifications"
        content.sound = .default
       // content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Ow.mp3"))
        let identifier = UUID().uuidString
        if let imageURL = Bundle.main.url(forResource: "beachball", withExtension: "png"){
            do{
        let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
                content.attachments = [attachment]
            } catch{
                print("couldn't get image \(error)")
            }
        } else {
            print("image resource could not be found")
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        // create a request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // add request to the UNNotificationCenter
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error adding request: \(error)")
            } else {
                print("request was successfully added")
            }
            
        }
    }
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        createLocalNotification()
        delegate?.didCreateNotification(self)
        dismiss(animated: true)
    }
    
}

extension CreatingVC: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case hourPickerView:
            hoursTime = Int(row) * 3600
            print(hoursTime + minutesTime + secondsTime)
            timeInterval = TimeInterval(hoursTime + minutesTime + secondsTime)
        case minPickerView:
            minutesTime = Int(row) * 60
            print(hoursTime + minutesTime + secondsTime)
            timeInterval = TimeInterval(hoursTime + minutesTime + secondsTime)
        case secPickerView:
            secondsTime = Int(row)
            print(hoursTime + minutesTime + secondsTime)
            timeInterval = TimeInterval(hoursTime + minutesTime + secondsTime)
        default:
            print("failed")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case hourPickerView:
            return 25
        case minPickerView, secPickerView:
            return 60
        default:
            0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case hourPickerView:
            var hours = [String]()
            for num in 0...25 {
                hours.append(num.description)
            }
            return hours[row]
        case minPickerView:
            var minutes = [String]()
            for min in 0...60 {
                minutes.append(min.description)
            }
            return minutes[row]
        case secPickerView:
            var seconds = [String]()
            for sec in 0...60 {
                seconds.append(sec.description)
            }
            return seconds[row]
        default:
            return "oops"
        }
        return "nope"
    }
}
