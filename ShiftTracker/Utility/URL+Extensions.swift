//
//  URL+Extensions.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 5/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Foundation

extension URL {
    public func addOrUpdateQueryStringParameter(key: String, value: String?) -> URL {
        if var components = URLComponents(url: self, resolvingAgainstBaseURL: true) {
            var queryItems = (components.queryItems ?? [])
            for (index, item) in queryItems.enumerated() {
                // Match query string key and update
                if item.name == key {
                    if let v = value {
                        queryItems[index] = URLQueryItem(name: key, value: v)
                    } else {
                        queryItems.remove(at: index)
                    }
                    components.queryItems = queryItems.count > 0
                        ? queryItems : nil
                    return components.url!
                }
            }
            
            // Key doesn't exist if reaches here
            if let v = value {
                // Add key to URL query string
                queryItems.append(NSURLQueryItem(name: key, value: v) as URLQueryItem)
                components.queryItems = queryItems
                return components.url!
            }
        }
        
        return self
    }
}
