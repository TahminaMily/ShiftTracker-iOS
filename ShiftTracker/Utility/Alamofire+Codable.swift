//
//  Alamofire+Codable.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 5/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Alamofire

public extension DataRequest {
    @discardableResult
    func responseObject<T: Decodable>(
        queue: DispatchQueue? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            if let error = error {
                return .failure(APIError.network(error: error))
            }

            guard var data = data else {
                return .failure(APIError.noData)
            }

            //Whoa!!! Fix the backend please
            if data == "null".data(using: .utf8) {
                data = "[]".data(using: .utf8)!
            }

            do {
                let responseObject = try decoder.decode(T.self, from: data)
                return .success(responseObject)
            } catch {
                return .failure(APIError.jsonSerialization(error: error))
            }
        }

        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
