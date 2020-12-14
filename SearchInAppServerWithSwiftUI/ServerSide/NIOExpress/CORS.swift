//
//  CORS.swift
//  SearchInAppServerWithSwiftUI
//
//  Created by FN on 12/8/20.
//

public func cors(allowOrigin origin: String) -> Middleware {
    return { req, res, next in
        res["Access-Control-Allow-Origin"]  = origin
        res["Access-Control-Allow-Headers"] = "Accept, Content-Type"
        res["Access-Control-Allow-Methods"] = "GET, OPTIONS"
        // we handle the options
        if req.header.method == .OPTIONS {
            res["Allow"] = "GET, OPTIONS"
            res.send("")
        }else{ // we set the proper headers
            next()
        }
    }
}
