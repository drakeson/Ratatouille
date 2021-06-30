//
//  DetailsVC.swift
//  Ratatouille
//
//  Created by Kato Drake Smith on 11/06/2021.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailsVC: UIViewController {

    var selectedId = ""
    var selectedName = ""
    var selectedAmount = ""
    var selectedImage = ""
    var selectedIngredients = ""
    var selectedDate = ""
    var selectedWaiter = ""
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var waiter: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = selectedName
        price.text = "Price: \(selectedAmount)"
        ingredients.text = "Ingredients: \(selectedIngredients)"
        date.text = "Order Date: \(selectedDate)"
        waiter.text = "Waiter: \(selectedWaiter)"
        
        
        ingredients.lineBreakMode = NSLineBreakMode.byWordWrapping
        ingredients.numberOfLines = 0
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        
        AF.request(selectedImage, method: .get).response{ response in
           switch response.result {
            case .success(let responseData):
                self.image.image = nil
                self.image.image = UIImage(data: responseData!)
            case .failure(let error):
                //image.image = #imageLiteral(resourceName: "placeholder")
                print("error---> ",error)
            }
        }
    }
    

    

}
