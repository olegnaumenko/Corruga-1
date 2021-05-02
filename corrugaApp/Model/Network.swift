//
//  Network.swift
//  Corruga
//
//  Created by oleg.naumenko on 29.04.2021.
//  Copyright © 2021 oleg.naumenko. All rights reserved.
//

import Foundation
import AFNetworking

let kNetworkErrorDomain = "com.corruga.nerwork.error"
let kResponseStatusErrorCode = 1001

enum NetworkResult {
    case Success(resource:Any, response:HTTPURLResponse)
    case Failure(error:Error)
}

protocol NetworkStackProtocol {
    func getJson(_ path: String, parameters: Any?, headerFields: [String:String]?, completion: @escaping (_ result: NetworkResult) -> Void)
    var networkIsAvailable:Bool {get}
}

class Network: NetworkStackProtocol {
    
    private let sessionManager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
    private let requestSerializer = AFHTTPRequestSerializer()
    
    init() {
        self.sessionManager.responseSerializer = AFJSONResponseSerializer()
        self.sessionManager.reachabilityManager.startMonitoring()
    }
    
    deinit {
        self.sessionManager.reachabilityManager.stopMonitoring()
    }
    
    var networkIsAvailable: Bool {
        return self.sessionManager.reachabilityManager.isReachable
    }
    
    func getJson(_ path: String, parameters: Any? = nil, headerFields: [String:String]? = nil, completion: @escaping (_ result: NetworkResult) -> Void) {

        guard let url = URL(string: path) else {
            print("Could not crete URL from path:", path)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        var nsErr: NSError?
        
        request = requestSerializer.request(bySerializingRequest: request, withParameters: parameters, error:&nsErr)!

        headerFields?.forEach({ (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        })
        
        sessionManager.dataTask(with: request, uploadProgress: nil, downloadProgress: nil) { (response, resourse, error) in
            if (error != nil) {
                completion(.Failure(error: error!))
            } else {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(.Success(resource: resourse ?? [:], response: httpResponse))
                } else {
                    let error = NSError(domain: kNetworkErrorDomain, code: kResponseStatusErrorCode, userInfo: nil)
                    completion(.Failure(error: error))
                }
            }
        }.resume()
        
    }
}
