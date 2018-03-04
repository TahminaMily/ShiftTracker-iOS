//
//  DataSource.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 4/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Foundation
import Alamofire

class DateSource {
    
    func fetchBusiness(completion: @escaping (Business?) -> Void) {
        
    }
    
    func fetchShifts(completion: @escaping ([Shift]?) -> Void) {
        APIRouter.sessionManager
            .request(APIRouter.shifts)
            .responseObject { (response: DataResponse<[Shift]>) in
                completion(response.value)
            }
    }
}
