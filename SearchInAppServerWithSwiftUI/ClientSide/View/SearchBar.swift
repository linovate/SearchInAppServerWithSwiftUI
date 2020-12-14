//
//  SearchBar.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/14/20.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var searchViewModel: SearchViewModel
        
    var body: some View {
        HStack {
            HStack {
                TextField(searchViewModel.isSearching ? searchViewModel.TYPE_PROMPT : searchViewModel.TAP_PROMPT,
                          text: $searchViewModel.text,
                          onEditingChanged: {_ in },
                          onCommit: {
                            searchViewModel.isSearching = false
                          })
                    .padding(.leading, searchViewModel.isSearching || searchViewModel.text != "" ? 0 : 24)
            }
            .padding(EdgeInsets(top:12, leading: 16, bottom: 12, trailing: 16))
            .background(Color(.systemGray5))
            .cornerRadius(16)
            .padding(EdgeInsets(top:8, leading: 14, bottom: 8, trailing: 14))
            .onTapGesture(perform: {
                searchViewModel.isSearching = true
            })
            .overlay(
                HStack {
                    //opacity == 0 makes Image completely invisible.
                    Image(systemName: "magnifyingglass")
                        .opacity(searchViewModel.isSearching || searchViewModel.text != "" ? 0 : 1)
                    Spacer()
                    Button(action: {
                        searchViewModel.text = ""
                        searchViewModel.queryResult = nil
                    }, label: {
                        //opacity == 0 makes Image completely invisible.
                        Image(systemName: "xmark")
                            .opacity(searchViewModel.text == "" ? 0 : 1)
                            .padding(.vertical)
                    })
                }
                .padding(EdgeInsets(top:0, leading: searchViewModel.isSearching ? 0 : 28, bottom: 0, trailing: 28))
                .foregroundColor(.gray)
            )
        }
    }
}
