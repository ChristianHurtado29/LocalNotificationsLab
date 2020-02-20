//
//  CreatingVC.swift
//  LocalNotificationsLab
//
//  Created by Christian Hurtado on 2/20/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit

class CreatingVC: UIViewController {
    
    @IBOutlet weak var hourPickerView: UIPickerView!
    @IBOutlet weak var minPickerView: UIPickerView!
    @IBOutlet weak var secPickerView: UIPickerView!

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
            return 61
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
            for min in 0...61 {
                minutes.append(min.description)
            }
            return minutes[row]
        case secPickerView:
            var seconds = [String]()
            for sec in 0...61 {
                seconds.append(sec.description)
            }
            return seconds[row]
        default:
            return "oops"
        }
        return "nope"
    }
}
