//
//  Ratatouille.swift
//  Ratatouille
//
//  Created by Kato Drake Smith on 11/06/2021.
//

import Foundation

struct Ratatouille {
    
    static let LENGTH = 32
    static let CHARACTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    //MARK:- MESSAGES
    static let success = "Successful"
    static let error = "Failed"
    static let load = "Loading..."
    static let tryA = "Try Again"
    static let OrderP = "Order Placed"
    static let topUpA = "Insufficient Balance!"
    
    //MARK:- DATABASES
    static let DISHDB = "history"
    static let USERSDB = "users"
    static let IMGSTO = "profilePics"
    static let ORDERSDB = "orders"


    //MARK:- ORDER
    static let DATE = "date"
    static let SORT = "sort"
    static let ID = "id"
    static let FOOD = "foodName"
    static let PRICE = "foodPrice"
    static let ING = "foodIngredients"
    static let WAITER = "waiter"
    static let IMAGE = "image"
    
    struct OrderData {
        static let DATE = "date"
        static let SORT = "sort"
        static let ID = "id"
        static let FOOD = "foodName"
        static let PRICE = "foodPrice"
        static let ING = "foodIngredients"
        static let WAITER = "waiter"
        static let IMAGE = "image"
    }
}
