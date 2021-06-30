//
//  ViewController.swift
//  Ratatouille
//
//  Created by Kato Drake Smith on 11/06/2021.
//

import UIKit
import Firebase
import SPAlert

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var orderTable: UITableView!
    let db = Firestore.firestore()
    var order: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderTable.dataSource = self
        orderTable.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) { loadOrders() }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orders = order[indexPath.row]
        let cell = orderTable.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableCell
        
        cell.orderName.text = orders.foodName
        cell.orderPrice.text = "Price: \(orders.foodPrice)"
        cell.orderIngredients.text = "Ingredients: \(orders.foodIngredients)"
        cell.orderDate.text = orders.date
        cell.orderWaiter.text = "Waiter: \(orders.waiter)"
        cell.orderIngredients.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.orderIngredients.numberOfLines = 0
        
        return cell
    }
    
    func loadOrders() {
        
        showLoader(true, withText: "Loading..")
        db.collection(Ratatouille.ORDERSDB)
            .order(by: Ratatouille.SORT, descending: true).limit(to: 20)
        .addSnapshotListener() { (querySnapshot, err) in
        self.order = []
        if let err = err {
            self.showLoader(false)
            SPAlert.present(title: "No Orders", preset: .exclamation)
            self.orderTable.isHidden = true
            print("Error getting documents: \(err)")
        } else {
            if let snapshotDocs = querySnapshot?.documents {
                for document in snapshotDocs {
                    let data = document.data()
                    if let id = data[Ratatouille.OrderData.ID] as? String,
                       let waiter = data[Ratatouille.OrderData.WAITER] as? String,
                       let food = data[Ratatouille.OrderData.FOOD] as? String,
                       let price = data[Ratatouille.OrderData.PRICE] as? String,
                       let ingredients = data[Ratatouille.OrderData.ING] as? String,
                       let image = data[Ratatouille.OrderData.IMAGE] as? String,
                       let date = data[Ratatouille.OrderData.DATE] as? String {
                       let newOrders = Order(id: id, foodName: food, foodPrice: price, foodIngredients: ingredients, waiter: waiter, date: date, image: image)
                        self.order.append(newOrders)
                        DispatchQueue.main.async { self.orderTable.reloadData() }
                        self.showLoader(false)
                    }
                    
                }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            let detailViewController = segue.destination as! DetailsVC
            let cell = sender as! UITableViewCell
            let indexPath = self.orderTable.indexPath(for: cell)
            let orderId = order[(indexPath?.row)!].id
            let orderName = order[(indexPath?.row)!].foodName
            let orderAmount = order[(indexPath?.row)!].foodPrice
            let orderImage = order[(indexPath?.row)!].image
            let orderIng = order[(indexPath?.row)!].foodIngredients
            let orderDate = order[(indexPath?.row)!].date
            let orderBy = order[(indexPath?.row)!].waiter

            detailViewController.selectedId = orderId
            detailViewController.selectedName = orderName
            detailViewController.selectedAmount = orderAmount
            detailViewController.selectedImage = orderImage
            detailViewController.selectedIngredients = orderIng
            detailViewController.selectedDate = orderDate
            detailViewController.selectedWaiter = orderBy
        }
        
    }
    
}

