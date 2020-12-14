//
//  ItemRow.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/14/20.
//

import SwiftUI

//For each row in search result.
struct ItemRow: View {
    let productModel: ProductModel
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(productModel.model).font(.headline)
                Spacer().frame(width:1, height:6)
                Text(productModel.inStock ? NSLocalizedString("In-stock", comment: "") : NSLocalizedString("Out-of-stock", comment: ""))
                    .font(.subheadline).foregroundColor(Color(.systemGray))
            }
            .padding(EdgeInsets(top:12, leading:16, bottom: 12, trailing: 0))
            
            Spacer().frame(height:1)
            
            VStack {
                Text("$\(productModel.price, specifier:"%.2f")").font(.subheadline)
            }
            .padding(EdgeInsets(top:6, leading:10, bottom: 6, trailing:10))
            //For the light blue background of in-stock product models.
            .background(productModel.inStock ? Color.init(red: 232/255, green: 232/255, blue: 1) : Color(.systemGray6))
            .foregroundColor(productModel.inStock ? Color(.systemBlue) : Color(.systemGray3))
            .cornerRadius(10)
            
            Spacer().frame(width:16, height:1)
        }
        .background(Color(.systemBackground))
    }
}

