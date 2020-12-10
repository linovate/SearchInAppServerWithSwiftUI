//
//  NIOExpress.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/8/20.
//

import Foundation
import NIO
import NIOHTTP1

open class NIOExpress : Router {
   
   let loopGroup =
      MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
   
   open func listen(_ port: Int) {
      
      let reuseAddrOpt = ChannelOptions.socket(
         SocketOptionLevel(SOL_SOCKET),
         SO_REUSEADDR)
      
      let bootstrap = ServerBootstrap(group: loopGroup)
         .serverChannelOption(ChannelOptions.backlog, value: 256)
         .serverChannelOption(reuseAddrOpt, value: 1)
         .childChannelInitializer { channel in
            
            channel.pipeline.configureHTTPServerPipeline().flatMap {
               channel.pipeline.addHandler(HTTPHandler(router: self))
            }
            
         }
         .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
         .childChannelOption(reuseAddrOpt, value: 1)
         .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)
      
      do {
         
         let serverChannel =
            try bootstrap.bind(host: "localhost", port: port)
            .wait()
         
         print("Server running on:", serverChannel.localAddress!)
         
         try serverChannel.closeFuture.wait() // runs forever
         
      } catch {
         fatalError("failed to start server: \(error)")
      }
   }
   
   
   final class HTTPHandler : ChannelInboundHandler {
      
      typealias InboundIn = HTTPServerRequestPart
      
      let router : Router
      
      init(router: Router) {
         self.router = router
      }
      
      func channelRead(context: ChannelHandlerContext, data: NIOAny) {
         
         let reqPart = unwrapInboundIn(data)
         
         switch reqPart {
            
            case .head(let header):
               
               let request  = IncomingMessage(header: header)
               let response = ServerResponse(channel: context.channel)
               
               // trigger Router
               router.handle(request: request, response: response) {
                  
                  (items : Any...) in // the final handler
                  response.status = .notFound // 404 error
                  response.send("No middleware handled the request!")
                  
               }
               
            // ignore incoming content to keep it light.
            case .body, .end: break
         }
      }
   }
   
}
