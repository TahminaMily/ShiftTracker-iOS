//
//  APIRouter.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 4/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift


enum APIRouter: URLRequestConvertible {
    case business
    case shiftStart(event: Shift.Event)
    case shiftEnd(event: Shift.Event)
    case shifts
    
    static let baseURLString = "https://apjoqdqpi3.execute-api.us-west-2.amazonaws.com/dmc"
    
    public static var sessionManager = SessionManager()
    
    static let decoder: JSONDecoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    static let encoder: JSONEncoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
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
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: event.dictionary)
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
        guard let data = try? APIRouter.encoder.encode(self) else { return nil }
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

class DeputyAuthAdapter: RequestAdapter {
    private let accessToken: String
    
    init(username: String) {
        self.accessToken = username.sha1()
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(APIRouter.baseURLString) {
            urlRequest.setValue("Deputy " + accessToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
