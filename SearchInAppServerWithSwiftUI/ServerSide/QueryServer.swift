//
//  QueryServer.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/8/20.
//

import Foundation


class QueryServer {
   
   let app = NIOExpress()
   
   init(){
      
      // Logging
      app.use { req, res, next in
         print("\(req.header.method):", req.header.uri)
         next() // continue processing
      }
      
      app.use(querystring, cors(allowOrigin: "*"))
      
      // Request Handling
      app.use { [weak self] req, res, _ in
         
         let reqHeaderUri = req.header.uri
         
         if reqHeaderUri.prefix(1) != "/"{
            print("Invalid URI: First Character of header uri is not /")
            return
         }
         
         if reqHeaderUri.count < 2 {
            print("Invalid URI: Number of characters in header uri is less than 2")
            return
         }
         
         let key = String(reqHeaderUri.suffix(reqHeaderUri.count - 1))
         
         if let productDictOfBrand = self?.serverData[key] {
            
            res.json(productDictOfBrand)
         
         }else{
            res.send("Brand Not Found")
         }
         
      }
      
      DispatchQueue.global(qos: .userInteractive).async {
         self.app.listen(Constants.SEVER_PORT)
      }
            
   }
   
   //Mock-up of Server Side Data. Therefore, typing "Dyson" and "iRobot" will return corresponding products on front end, typing any other term will return nothing.
   private let serverData = [
      
      "Dyson": Products (productDict:
                           
                           ["Vacuum":
                              
                              [ ProductModel(model:"V11", inStock:true, price:599.99),
                                
                                ProductModel(model:"V10", inStock:false, price:399.99) ],
                            
                            "Hair Dryer":
                              
                              [ ProductModel(model:"Supersonic", inStock:true, price:399.99) ]
                            
                           ]
               ),
      
      
      "iRobot": Products (productDict:
                           
                           ["Vacuum":
                              
                              [ ProductModel(model:"S9", inStock:true, price:899.99),
                                
                                ProductModel(model:"i7", inStock:true, price:599.99),
                                
                                ProductModel(model:"i3", inStock:false, price:399.99) ],
                            
                            "Mop":
                              
                              [ ProductModel(model:"M6", inStock:true, price:399.99) ]
                            
                           ]
               )
      
   ]
   
}
