//
//  ContentView.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/7/20.
//

import SwiftUI
import Combine


struct ContentView: View {
   
   let server = QueryServer()
   
   @State var searchText = ""
   @State var isSearching = false
   @State var queryResult : Products?
   
   static let defaultArrayOfProductModels =  [ProductModel(model:"Default Model", inStock:false, price:0)]
   
   init(){
      UITableView.appearance().tableFooterView = UIView()
      UITableView.appearance().separatorStyle = .none
   }
   
   var body: some View {
      
      NavigationView {

         ZStack {
            //Sets light gray as background color.
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            ScrollView {
               //(spacing:2) sets 2 as the spacing between items in search result.
               LazyVStack(spacing:2){
                  
                  SearchBar(searchText: $searchText, isSearching: $isSearching, queryResult: $queryResult)
                  
                  if let qr = queryResult {
                     //For each Brand
                     ForEach(qr.productDict.keys.sorted().reversed(), id: \.self) { key in
                        
                        Section(header:
                                 
                                 HStack {
                                    
                                    Text(key).font(.title2).fontWeight(.medium).foregroundColor(Color(.systemGray))
                                       .padding(EdgeInsets(top:8, leading:16, bottom: 8, trailing:0))
                                    
                                    Spacer()
                                    
                                 }
                                
                        ){
                           //For each product model
                           ForEach(qr.productDict[key] ?? ContentView.defaultArrayOfProductModels, id: \.self) { item in
                              
                              ItemRow(productModel:item).listRowInsets(.init())
                              
                           }
                           
                        }
                     }
                  }
               }
            }.navigationTitle("Search")
            .navigationBarHidden(isSearching)
         }
      }
   }
}


struct SearchBar: View {
   
   @Binding var searchText: String
   @Binding var isSearching: Bool
   @Binding var queryResult: Products?
   
   var body: some View {
      
      HStack {
         
         HStack {
            
            TextField(isSearching ? "Enter search term" : "Tap here to search", text: $searchText, onEditingChanged: {_ in }, onCommit: {
               isSearching = false
            }
            )
            .onChange(of: searchText) { searchText in
               
               if searchText != "" {
                  makeServerQuery(searchTerm: searchText)
               }
               
            }
            .padding(.leading, isSearching || searchText != "" ? 0 : 24)
            
         }
         .padding(EdgeInsets(top:12, leading: 16, bottom: 12, trailing: 16))
         .background(Color(.systemGray5))
         .cornerRadius(16)
         .padding(EdgeInsets(top:8, leading: 14, bottom: 8, trailing: 14))
         .onTapGesture(perform: {
            isSearching = true
         })
         .overlay(
            
            HStack {
               //opacity == 0 makes Image completely invisible.
               Image(systemName: "magnifyingglass").opacity(isSearching || searchText != "" ? 0 : 1)
               
               Spacer()
               
               Button(action: {
                  
                  searchText = ""
                  queryResult = nil
                  
               }, label: {
                  //opacity == 0 makes Image completely invisible.
                  Image(systemName: "xmark").opacity(searchText == "" ? 0 : 1)
                     .padding(.vertical)
               })
               
            }
            .padding(EdgeInsets(top:0, leading: isSearching ? 0 : 28, bottom: 0, trailing: 28))
            .foregroundColor(.gray)
            
         )
      }
   }
   
   
   func makeServerQuery(searchTerm: String) {
      
      if let url = URL(string: Constants.QUERY_URL_STRING + searchTerm) {
         
         URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            guard let data = data else { return }
            
            if let decodedResponse = try? JSONDecoder().decode(Products.self, from: data){
               
               DispatchQueue.main.async {
                  queryResult = decodedResponse
               }
               
            }else{
               queryResult = nil
            }
            
         }.resume()
         
      }
   }
   
}

//For each row in search result.
struct ItemRow: View {
   
   let productModel: ProductModel
   
   var body: some View {
      
      HStack {
         
         VStack (alignment: .leading) {
            
            Text(productModel.model).font(.headline)
            
            Spacer().frame(width:1, height:6)
            
            Text(productModel.inStock ? "In-stock" : "Out-of-stock")
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


struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      HStack {
         ContentView()
      }.previewLayout(.fixed(width: 600, height: 600))
   }
}
