//
//  Middleware.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/8/20.
//

public typealias Next = ( Any... ) -> Void

public typealias Middleware =
   ( IncomingMessage,
     ServerResponse,
     @escaping Next ) -> Void
