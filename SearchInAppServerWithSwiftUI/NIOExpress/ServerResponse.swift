//
//  ServerResponse.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/8/20.
//

import NIO
import NIOHTTP1

open class ServerResponse {
   
   public  var status         = HTTPResponseStatus.ok
   public  var headers        = HTTPHeaders()
   public  let channel        : Channel
   private var didWriteHeader = false
   private var didEnd         = false
   
   public init(channel: Channel) {
      self.channel = channel
   }
   
   /// An Express like `send()` function.
   open func send(_ s: String) {
      
      flushHeader()
      
      var buffer = channel.allocator.buffer(capacity: s.count)
      buffer.writeString(s)
      
      let part = HTTPServerResponsePart.body(.byteBuffer(buffer))
      
      _ = channel.writeAndFlush(part)
         .recover(handleError)
         .map(end)
      
   }
   
   /// Check whether we already wrote the response header.
   /// If not, do so.
   func flushHeader() {
      
      guard !didWriteHeader else { return } // done already
      didWriteHeader = true
      
      let head = HTTPResponseHead(version: .init(major:1, minor:1),
                                  status: status, headers: headers)
      let part = HTTPServerResponsePart.head(head)
      _ = channel.writeAndFlush(part).recover(handleError)
      
   }
   
   func handleError(_ error: Error) {
      print("ERROR:", error)
      end()
   }
   
   func end() {

      guard !didEnd else { return }
      
      didEnd = true
      
      _ = channel.writeAndFlush(HTTPServerResponsePart.end(nil))
         .map { self.channel.close() }

   }
   
}


public extension ServerResponse {
   
   /// A more convenient header accessor. Not correct for
   /// any header.
   subscript(name: String) -> String? {
      
      set {
         assert(!didWriteHeader, "header is out!")
         
         if let v = newValue {
            headers.replaceOrAdd(name: name, value: v)
         }else {
            headers.remove(name: name)
         }
      }
      
      get {
         return headers[name].joined(separator: ", ")
      }
      
   }
   
}


import struct Foundation.Data
import class  Foundation.JSONEncoder

public extension ServerResponse {
   
   /// Send a Codable object as JSON to the client.
   func json<T: Encodable>(_ model: T) {
      
      // create a Data struct from the Codable object
      let data : Data
      
      do {
         data = try JSONEncoder().encode(model)
      }catch {
         return handleError(error)
      }
      
      // setup JSON headers
      self["Content-Type"]   = "application/json"
      self["Content-Length"] = "\(data.count)"
      
      // send the headers and the data
      flushHeader()
      
      var buffer = channel.allocator.buffer(capacity: data.count)
      buffer.writeBytes(data)
      let part = HTTPServerResponsePart.body(.byteBuffer(buffer))
      
      _ = channel.writeAndFlush(part)
         .recover(handleError)
         .map(end)
   }
   
}
