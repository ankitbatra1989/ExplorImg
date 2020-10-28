//
//  EICodableTasks.swift
//  ExplorImg
//
//  Created by Ankit Batra on 27/10/20.
//

import Foundation
import EINetworkingKit

enum EICodableTask {
    case getImagesFromPixabay(String, Int, (Result<ImageContainerModel?, Error>) -> Void)
}

extension EICodableTask: EICodableDataTask {
    var urlDataTask: URLSessionDataTask? {
        switch self {
        case .getImagesFromPixabay(let searchText,let pageNumber, let completion):
            guard let urlRequest = EIRequest.searchPixabayForImagesWith(searchText, pageNumber).urlRequest else { return nil }
            return EIURLSession.sharedInstance.session?.codableResultTask(with: urlRequest, completion: completion)
        }
    }
}
