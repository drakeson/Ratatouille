//
//  OrderVM.swift
//  Ratatouille
//
//  Created by Kato Drake Smith on 11/06/2021.
//

import Foundation
import Firebase

class OrderVM: NSObject {
    typealias orderCallBack = (_ status:Bool, _ message:String) -> Void
    var orderCB:orderCallBack?
    let db = Firestore.firestore()
    
    //MARK:- UPDATE MY HISTORY
    
    func addOrder(_ name:String, food:String, price:String, ingredients:String, date:String, image:String) {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        db.collection(Ratatouille.ORDERSDB).addDocument(data: [
            Ratatouille.WAITER: name,
            Ratatouille.FOOD: food,
            Ratatouille.PRICE: price,
            Ratatouille.ING: ingredients,
            Ratatouille.DATE: date,
            Ratatouille.IMAGE: image,
            Ratatouille.SORT: "\(Int(since1970))",
            Ratatouille.ID: NSUUID().uuidString.lowercased()
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                self.orderCB?(false, "\(err)")
            } else {
                self.orderCB?(true, Ratatouille.success)
            }
        }
    }
    
    
    //MARK:- User CompletionHandler
    func orderCompletionHandler(callBack: @escaping orderCallBack) {
        self.orderCB = callBack
    }
    
}
