//
//  String+Error.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 5/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import Foundation

//simplest way to create an error

extension String: Error { }

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
