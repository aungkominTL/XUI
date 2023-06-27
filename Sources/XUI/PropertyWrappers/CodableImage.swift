//
//  File.swift
//  
//
//  Created by Aung Ko Min on 26/6/23.
//

import UIKit


@propertyWrapper
public struct CodableImage: Codable {

    var image: UIImage?

    public enum CodingKeys: String, CodingKey {
        case image
    }

    public init(image: UIImage?) {
        self.image = image
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let b = try? container.decodeNil(forKey: CodingKeys.image), b {

            self.image = nil

        } else {

            let data = try container.decode(Data.self, forKey: CodingKeys.image)

            guard let image = UIImage(data: data) else {
                throw DecodingError.dataCorruptedError(forKey: CodingKeys.image, in: container, debugDescription: "Decoding image failed")
            }

            self.image = image

        }

    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let data = image?.pngData() {
            try container.encode(data, forKey: CodingKeys.image)
        } else {
            try container.encodeNil(forKey: CodingKeys.image)
        }
    }

    public init(wrappedValue: UIImage?) {
        self.init(image: wrappedValue)
    }

    public var wrappedValue: UIImage? {
        get { image }
        set {
            image = newValue
        }
    }

}

enum ImageEncodingQuality {
    case png
    case jpeg(quality: CGFloat)
}

extension KeyedEncodingContainer {
    mutating func encode(
        _ value: UIImage,
        forKey key: KeyedEncodingContainer.Key,
        quality: ImageEncodingQuality = .png
    ) throws {
        let imageData: Data?
        switch quality {
        case .png:
            imageData = value.pngData()
        case .jpeg(let quality):
            imageData = value.jpegData(compressionQuality: quality)
        }
        guard let data = imageData else {
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(codingPath: [key], debugDescription: "Failed convert UIImage to data")
            )
        }
        try encode(data, forKey: key)
    }
}

extension KeyedDecodingContainer {
    func decode(
        _ type: UIImage.Type,
        forKey key: KeyedDecodingContainer.Key
    ) throws -> UIImage {
        let imageData = try decode(Data.self, forKey: key)
        if let image = UIImage(data: imageData) {
            return image
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [key], debugDescription: "Failed load UIImage from decoded data")
            )
        }
    }
}
