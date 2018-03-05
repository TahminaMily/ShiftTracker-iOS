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
    
    public static var sessionManager = SessionManager()
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Formatters.jsonDateFormatter)
        return decoder
    }()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(Formatters.jsonDateFormatter)
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
        case .shiftStart(let event):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: event.dictionary)
        case .shiftEnd(let event):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: event.dictionary)
        case .business, .shifts:
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

private extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? APIRouter.encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
