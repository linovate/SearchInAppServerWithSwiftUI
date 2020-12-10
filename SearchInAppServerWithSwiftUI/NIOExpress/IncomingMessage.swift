//
//  IncomingMessage.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/8/20.
//

import NIOHTTP1

open class IncomingMessage {
   
   public let header   : HTTPRequestHead // <= from NIOHTTP1
   public var userInfo = [ String : Any ]()
   
   init(header: HTTPRequestHead) {
      self.header = header
   }
   
}
