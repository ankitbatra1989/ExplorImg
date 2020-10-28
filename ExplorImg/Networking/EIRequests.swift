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
            let parameters = ["key": "18845187-c6b9454035cf7da433297032c",
                              "q": searchText,
                              "image_type": "photo",
                              "per_page": "20",
                              "page": "\(pageNumber)"]
            return EIURLRequest(urlPath: endPoint, type: .get, parameters: parameters).requestObject
        }
    }
}
