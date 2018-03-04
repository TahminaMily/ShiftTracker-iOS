//
//  Models.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 4/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Foundation
import CoreLocation

struct Business: Codable {
    let name: String
    let logo: URL
}


struct Shift: Codable {
    let id: Int
    let start: String
    let end: String
    let startLatitude: String
    let startLongitude: String
    let endLatitude: String
    let endLongitude: String
    let image: URL
}

extension Shift {
    struct Event: Codable {
        let time: Date
        let latitude: Double
        let longitude: Double
        
        enum CodingKeys: String, CodingKey {
            case time
            case latitude
            case longitude
        }
        
        public init(time: Date, latitude: Double, longitude: Double) {
            self.time = time
            self.latitude = latitude
            self.longitude = longitude
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            time = try container.decode(Date.self, forKey: .time)
            guard
                let latitudeString = try? container.decode(String.self, forKey: .latitude),
                let longitudeString = try? container.decode(String.self, forKey: .longitude),
                let latitude = Double(latitudeString),
                let longitude = Double(longitudeString)
                else {
                    throw DecodingError.typeMismatch(Double.self, DecodingError.Context(codingPath: [CodingKeys.latitude], debugDescription: "??"))
            }

            self.latitude = latitude
            self.longitude = longitude
        }
        
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(time, forKey: .time)
            try container.encode(String(latitude), forKey: .latitude)
            try container.encode(String(longitude), forKey: .longitude)
        }
    }
}
