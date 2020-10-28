//
//  EIRequests.swift
//  ExplorImg
//
//  Created by Ankit Batra on 27/10/20.
//

import Foundation
import EINetworkingKit

// MARK: - VCC
enum EIRequest {
    case searchPixabayForImagesWith(String, Int)
}
extension EIRequest: EIURLRequestProtocol {
    var urlRequest: URLRequest? {
        switch self {
        case .searchPixabayForImagesWith(let searchText, let pageNumber):
            let endPoint = "\(EINetworkingConstants.HOST)/api/"
            let parameters = ["key": EINetworkingConstants.API_KEY,
                              "q": searchText,
                              "image_type": "photo",
                              "per_page": "20",
                              "page": "\(pageNumber)"]
            return EIURLRequest(urlPath: endPoint, type: .get, parameters: parameters).requestObject
        }
    }
}
