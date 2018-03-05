//
//  DeputyAuthAdapter.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 5/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Alamofire
import CryptoSwift

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
