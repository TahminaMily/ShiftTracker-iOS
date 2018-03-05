//
//  DataSource.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 4/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Foundation
import Alamofire
import Cache

class DataSource {
    let storage = try? Storage(diskConfig: DiskConfig(name: "Disk"))

    func fetchBusiness(completion: @escaping (Alamofire.Result<Business>) -> Void) {
        APIRouter.sessionManager
            .request(APIRouter.business)
            .responseObject { [weak self] (response: DataResponse<Business>) in
                //store in cache if successfull
                var result = response.result
                switch response.result {
                case .success(let business):
                    try? self?.storage?.setObject(business, forKey: "business")
                case .failure:
                    if let business:Business = (try? self?.storage?.object(ofType: Business.self, forKey: "business"))?.flatMap({ $0 }) {
                        result = .success(business)
                    }
                }
                DispatchQueue.main.async { completion(result) }
            }
    }
    
    func fetchShifts(completion: @escaping (Alamofire.Result<[Shift]>) -> Void) {
        APIRouter.sessionManager
            .request(APIRouter.shifts)
            .responseObject { [weak self] (response: DataResponse<[Shift]>) in
                //store in cache if successfull
                var result = response.result
                switch response.result {
                case .success(let shifts):
                    try? self?.storage?.setObject(shifts, forKey: "shifts")
                case .failure:
                    if let shifts: [Shift] = (try? self?.storage?.object(ofType: [Shift].self, forKey: "shifts"))?.flatMap({ $0 }) {
                        result = .success(shifts)
                    }
                }
                DispatchQueue.main.async { completion(result) }
            }
    }
}
