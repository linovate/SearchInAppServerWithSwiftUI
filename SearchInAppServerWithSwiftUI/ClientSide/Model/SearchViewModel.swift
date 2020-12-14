//
//  SearchTextViewModel.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/13/20.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var title = "Search"
    @Published var text = ""
    @Published var isSearching = false
    @Published var queryResult: Products?
    
    let DEFAULT_ARRAY_OF_PRODUCT_MODELS =  [ProductModel(model: NSLocalizedString("Default Model", comment: ""), inStock:false, price:0)]
    let TAP_PROMPT = NSLocalizedString("Tap here to search", comment: "")
    let TYPE_PROMPT = NSLocalizedString("Enter search term", comment: "")
    
    private var subscriber: AnyCancellable?
    
    init(){
        let publisher = Publishers.CombineLatest($text, $isSearching)
            .debounce(for: .milliseconds(600), scheduler: RunLoop.main)
            .map({
                text, isSearching -> String in
                return text
            })
            .filter({ $0.count > 0 })
            .removeDuplicates()
            .receive(on: RunLoop.main)
        
        subscriber = publisher.sink { [weak self] txt in
            self?.makeServerQuery(searchTerm: txt)
        }
    }
    
    func makeServerQuery(searchTerm: String) {
        if let url = URL(string: Constants.QUERY_URL_STRING + searchTerm) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let data = data else { return }
                if let decodedResponse = try? JSONDecoder().decode(Products.self, from: data){
                    DispatchQueue.main.async {
                        self?.queryResult = decodedResponse
                    }
                }else{
                    DispatchQueue.main.async {
                        self?.queryResult = nil
                    }
                }
            }.resume()
        }
    }
}
