//
//  Date.swift
//  Tiki
//
//  Created by Carlos Pendola on 4/5/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//
/*
extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}*/

import UIKit

extension Date{
    func string(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
