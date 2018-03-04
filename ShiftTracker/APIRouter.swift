//
//  APIRouter.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 4/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Foundation
import Alamofire


enum APIRouter: URLRequestConvertible {
    case business
    case shiftStart(event: Shift.Event)
    case shiftEnd(event: Shift.Event)
    case shifts
    
    static let baseURLString = "https://apjoqdqpi3.execute-api.us-west-2.amazonaws.com/dmc"
    var method: HTTPMethod {
        switch self {
        case .business: return .get
        case .shiftStart: return .post
        case .shiftEnd: return .post
        case .shifts: return .get
        }
    }
    
    var path: String {
        switch self {
        case .business: return "/business"
        case .shiftStart: return "/shift/start"
        case .shiftEnd: return "/shift/end"
        case .shifts: return "/shifts"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try APIRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .business:
            break
        case .shiftStart(let event):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: event.dictionary)
        case .shiftEnd(let event):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: event.dictionary)
        case .shifts:
            break
        }
        
        return urlRequest
    }
}

enum APIError: Error {
    case network(error: Error)
    case noData
    case jsonSerialization(error: Error)
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

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
            
            guard let data = data else {
                return .failure(APIError.noData)
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
