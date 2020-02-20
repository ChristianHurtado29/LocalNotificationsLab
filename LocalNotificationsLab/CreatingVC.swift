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
    
    @IBOutlet weak var hourPickerView: UIPickerView!
    @IBOutlet weak var minPickerView: UIPickerView!
    @IBOutlet weak var secPickerView: UIPickerView!
    
    weak var delegate: CreatingVCDelegate?
    
    private var timeInterval: TimeInterval =
    Date().timeIntervalSinceNow + 5 

    override func viewDidLoad() {
        super.viewDidLoad()
        hourPickerView.delegate = self
        minPickerView.delegate = self
        secPickerView.delegate = self
        hourPickerView.dataSource = self
        minPickerView.dataSource = self
        secPickerView.dataSource = self

    }
    

    
}

extension CreatingVC: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
