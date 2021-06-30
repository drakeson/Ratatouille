//
//  FoodPicker.swift
//  Ratatouille
//
//  Created by Kato Drake Smith on 11/06/2021.
//


import UIKit
import PickerButton

class FoodPicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerValues: [String] = ["Select Food"]

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }

}
