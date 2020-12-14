//
//  ContentView.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/7/20.
//

import SwiftUI

struct ContentView: View {
    let server = QueryServer()
    
    @ObservedObject var searchViewModel = SearchViewModel()
            
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
                        SearchBar(searchViewModel: searchViewModel)
                        if let qr = searchViewModel.queryResult {
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
                                    ForEach(qr.productDict[key] ?? searchViewModel.DEFAULT_ARRAY_OF_PRODUCT_MODELS, id: \.self) { item in
                                        ItemRow(productModel:item).listRowInsets(.init())
                                    }
                                }
                            }
                        }
                    }
                }.navigationTitle(searchViewModel.title)
                 .navigationBarHidden(searchViewModel.isSearching)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ContentView()
        }.previewLayout(.fixed(width: 600, height: 600))
    }
}
