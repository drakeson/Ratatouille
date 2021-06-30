//
//  AddVC.swift
//  Ratatouille
//
//  Created by Kato Drake Smith on 11/06/2021.
//

import UIKit
import Firebase
import DatePicker
import SPAlert
import PickerButton


class AddVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var foodPickerBtn: PickerButton!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var waiterName: UITextField!
    @IBOutlet weak var orderPlace: UIButton!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderIng: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    var pickerValues: [String] = ["Select Food"]
    var imageURL = ""
    var foodSelected = 0
    var orderVM = OrderVM()
    var ref : DatabaseReference!
    var refHandle : DatabaseHandle?
    var foodList = [Food]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadFoods()
    }
    
    func configureUI(){
        self.setupToHideKeyboardOnTapOnView()
        orderPlace.isEnabled = false
        foodPickerBtn.delegate = self
        foodPickerBtn.dataSource = self
        orderImage.layer.borderWidth = 1
        orderImage.layer.masksToBounds = false
        orderImage.layer.borderColor = UIColor.black.cgColor
        orderImage.layer.cornerRadius = 5
        orderImage.clipsToBounds = true
        
        dateBtn.layer.borderWidth = 1
        dateBtn.layer.cornerRadius = 5
        dateBtn.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        dismissKeyboard()
    }
    
    
    //MARK:- Loading Food
    func loadFoods(){
        showLoader(true, withText: "Loading Food")
        pickerValues.removeAll()
        ref = Database.database().reference().child("food")
        ref.observe(.value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                let notesDict = childSnapshot.value as? [String: Any],
                let name = notesDict["name"] as? String,
                let price = notesDict["price"] as? String,
                let ingredients = notesDict["ingredients"] as? Array<String>,
                let id = notesDict["id"] as? String {
                    let ingred = ingredients.joined(separator: ", ")
                    let food = Food(id: id, name: name, price: price, ingredients: ingred)
                    self.pickerValues.append(name)
                    self.foodList.append(food)
                }
                self.showLoader(false)
                print("Food: \(self.foodList)")
            }
        }
    }
    //MARK:- Loading Food End
    
    
    
    
    
    
    //MARK:- Add Image
    @IBAction func addImage(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    //MARK:- Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        orderImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        let imgData = orderImage.image!.jpegData(compressionQuality: 0.75)
        let randomCharacters = (0..<Ratatouille.LENGTH).map{_ in Ratatouille.CHARACTERS.randomElement()!}
        let randomString = String(randomCharacters)
        showLoader(true, withText: "Uploading Image...")
        let storageReference = Storage.storage().reference().child("profilePics/").child(randomString + ".jpg")
        storageReference.putData(imgData!, metadata: nil, completion: { (metadata, error) in
              if error != nil {
                print("Error 1: \(error!)")
                self.showLoader(false)
              }
              storageReference.downloadURL(completion: { (url, error) in
                  if error != nil {
                    self.showLoader(false)
                    print("Error 2: \(error!)")
                  }
                self.showLoader(false)
                  if let urlText = url?.absoluteString {
                    self.orderPlace.isEnabled = true
                    self.imageURL = urlText as String
                    self.orderPlace.isEnabled = true
                    print("Image: \(self.imageURL)")
                  }
              })
        })
    }
    //MARK:- Add Image End
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Create Order
    @IBAction func createOrder(_ sender: Any) {
        let name = waiterName.text!
        let food = foodPickerBtn.currentTitle!
        let date = dateBtn.currentTitle!
        let price = orderPrice.text!
        let ingredients = orderIng.text!
        let image = self.imageURL
        
        if name.count < 3 {
            SPAlert.present(title: "Please Enter Waiter's Name", preset: .error)
        } else if food == "Select Food" {
            SPAlert.present(title: "Please Select Food", preset: .error)
        } else if date == "  Order Date 📅" {
            SPAlert.present(title: "Please Select Order Date", preset: .error)
        } else {
            showLoader(true, withText: "Placing Order")
            self.orderVM.orderCompletionHandler { [weak self] (status, message) in
                guard self != nil else {return}
                if status {
                    self!.showLoader(false)
                    SPAlert.present(title: message, message: Ratatouille.OrderP, preset: .done)
                } else {
                    self?.showLoader(false)
                    SPAlert.present(title: "Error", message: message, preset: .error)
                }
            }
            self.orderVM.addOrder(name, food: food, price: price, ingredients: ingredients, date: date, image: image)
        }
        
        
    }
    //MARK:- Create Order End
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Date Picker
    @IBAction func datePick(_ sender: Any) {
        let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 1990)!
                let maxDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2030)!
                let today = Date()
                // Create picker object
                let datePicker = DatePicker()
                // Setup
                datePicker.setup(beginWith: today, min: minDate, max: maxDate) { (selected, date) in
                    if selected, let selectedDate = date {
                        print(selectedDate.string())
                        self.dateBtn.setTitle("  \(selectedDate.string())", for: .normal)
                    } else {
                        print("Cancelled")
                    }
                }
        datePicker.show(in: self, on: sender as? UIView)
    }
    
    //MARK:- Date Picker End
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Food Picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.foodSelected = row
        self.orderPrice.text = foodList[row].price
        self.orderIng.text = foodList[row].ingredients
    }
    //MARK:- Food Picker End
    
    
}

