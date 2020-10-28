//
//  ExploreImagesModels.swift
//  ExplorImg
//
//  Created by Ankit Batra on 25/10/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum ImageDownloadState {
    case New, Downloaded, Failed
}

struct ImageContainerModel: Decodable {
    var hits: [ImageDataModel]?
}

class ImageDataModel : Codable {

    //MARK: Properties
    var type: String? // "photo",
    var tags: [String]? // "sunflower, nature, flora",
    var previewURL: String? //"https://cdn.pixabay.com/photo/2018/01/28/11/24/sunflower-3113318_150.jpg",
    var previewWidth: Int?
    var previewHeight: Int?
    var largeImageURL: String? // "https://pixabay.com/get/55e1d4404953a414f6da8c7dda7936761d3bdbe45b566c48732f78d29745c15db8_1280.jpg",
    var imageState = ImageDownloadState.New
    var largeImageState = ImageDownloadState.New

    enum CodingKeys: String, CodingKey {
        case type
        case tags
        case previewURL
        case previewWidth
        case previewHeight
        case largeImageURL
    }
    
    //MARK: Initialization
    required init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        type = try? values?.decodeIfPresent(String.self, forKey: .type)
        tags = try? values?.decodeIfPresent([String].self, forKey: .tags)
        previewURL = try? values?.decodeIfPresent(String.self, forKey: .previewURL)
        previewWidth = try? values?.decodeIfPresent(Int.self, forKey: .previewWidth)
        previewHeight = try? values?.decodeIfPresent(Int.self, forKey: .previewHeight)
        largeImageURL = try? values?.decodeIfPresent(String.self, forKey: .largeImageURL)
    }
}
