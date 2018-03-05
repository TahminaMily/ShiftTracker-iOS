//
//  DataSource.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 4/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Foundation
import Alamofire

class DataSource {
    func fetchBusiness(completion: @escaping (Result<Business>) -> Void) {
        APIRouter.sessionManager
            .request(APIRouter.business)
            .responseObject { (response: DataResponse<Business>) in
                DispatchQueue.main.async { completion(response.result) }
            }
    }
    
    func fetchShifts(completion: @escaping (Result<[Shift]>) -> Void) {
        APIRouter.sessionManager
            .request(APIRouter.shifts)
            .responseObject { (response: DataResponse<[Shift]>) in
                DispatchQueue.main.async { completion(response.result) }
            }
    }

    func startShift(at: Shift.Event, completion: (Result<Void>) -> Void) {

    }
}
