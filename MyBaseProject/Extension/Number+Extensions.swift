//
//  Number+Extensions.swift
//  OSEIOS
//
//  Created by ECO0542-HoangNM on 01/03/2022.
//

import Foundation

extension Numeric {
    var data: Data {
        var source = self
        // This will return 1 byte for 8-bit, 2 bytes for 16-bit, 4 bytes for 32-bit and 8 bytes for 64-bit binary integers. For floating point types it will return 4 bytes for single-precision, 8 bytes for double-precision and 16 bytes for extended precision.
        return .init(bytes: &source, count: MemoryLayout<Self>.size)
    }
}

extension Int64 {
    func fomatString(digits: Int = 0) -> String {
        return CommonFunction.makeStringMoney(from: Double(self), maximumFractionDigits: digits)
    }
}


