//
//  Collection+Extension.swift
//  OSEIOS (iOS)
//
//  Created by ECO0542-HoangNM on 05/11/2021.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension Array {
    /// Split an array to subArray and keep this order
    /// [a,b,c,d,e] -> [[a,b],[c,d],[e]]
    func splitSubArraysWithinOrder(into size: Int) -> [[Element]] {
        var newArray = self
        return (0..<size).map { subSize in
            let length = Int((Double(newArray.count) / Double(size - subSize)).rounded(.up))
            let subArray = newArray.prefix(length)
            if newArray.count >= length {
                newArray.removeSubrange(0..<length)
            } else {
                newArray.removeAll()
            }
            return Array(subArray)
        }
    }
    /// Split an array to subArray that jump between index
    /// [a,b,c,d,e] -> [[a,c,e],[b,d]]
    func splitInSubArrays(into size: Int) -> [[Element]] {
        return (0..<size).map {
            stride(from: $0, to: count, by: size).map { self[$0] }
        }
    }
}
