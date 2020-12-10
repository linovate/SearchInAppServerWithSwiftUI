//
//  DataModel.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/9/20.
//

//Both need to conform to Codable for JSON Decoder.

struct Products: Codable {

   var productDict: [String: [ProductModel]]
   
}

//Need to be Hashable for ForEach to work.
struct ProductModel: Hashable, Codable {

   var model: String
   var inStock: Bool
   var price: Float
   
}
