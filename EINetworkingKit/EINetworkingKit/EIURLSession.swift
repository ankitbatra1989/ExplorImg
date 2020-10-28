//
//  EIURLSession.swift
//  EINetworkingKit
//
//  Created by Ankit Batra on 27/10/20.
//

import Foundation


public class EIURLSession: NSObject {

    public static let sharedInstance = EIURLSession()

    public var session: URLSession?
    weak var delegate: URLSessionDelegate!

    fileprivate override init() {
        super.init()
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60
        sessionConfig.timeoutIntervalForResource = 60
        session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: queue)
    }
}

//extension EIURLSession: URLSessionDelegate {
//
//    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        // Handle SSL Pinning here
//        return
//    }
//
//}

extension URLSession {
    
    public func codableResultTask<T: Decodable>(with request: URLRequest, completion: ((Result<T?, Error>) -> Void)? = nil) -> URLSessionDataTask {
        return self.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                    print("Http response status code is \(httpResponse.statusCode)")
                    return
                }
                guard let data = data, error == nil else {
                    #if DEBUG
                    let reqString = "\n------------------------------\n\(request.httpMethod ?? "") URL     :  \(request.url?.absoluteString ?? "") \nHeader       :  \(request.allHTTPHeaderFields ?? [:]) \nRequestBody         : \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "") \nRecieved Error         : \(error?.localizedDescription ?? "") \n------------------------------\n"
                    print(reqString)
                    #endif
                    completion?(.failure(error!))
                    return
                }
                #if DEBUG
                let reqString = "\n------------------------------\n\(request.httpMethod ?? "") URL     :  \(request.url?.absoluteString ?? "") \nHeader       :  \(request.allHTTPHeaderFields ?? [:]) \nRequestBody         : \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "") \nRecieved Data         : \(String(data: data, encoding: .utf8) ?? "") \n------------------------------\n"
                print(reqString)
                #endif
                completion?(.success((try? JSONDecoder().decode(T.self, from: data))))
            }
        }
    }
    
}

public protocol EICodableDataTask {
    var urlDataTask: URLSessionDataTask? { get }
}

public protocol EIURLRequestProtocol {
    var urlRequest: URLRequest? { get }
}
