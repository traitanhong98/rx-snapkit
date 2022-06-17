//
//  Dict+Extension.swift
//  Pmobile3
//
//  Created by ECO00528_DUONGCT on 7/8/21.
//

import Foundation

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension Encodable {
    /// Make dict from this object
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    /// Convert data to string
    func toString()  -> String? {
        guard let dictionary = dictionary else {
            return nil
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            return nil
        }
    }
    /// Check if any variable have path name
    func hasKey(for path: String) -> Bool {
        return Mirror(reflecting: self).children.contains { $0.label == path }
    }
    /// Return value of a variable name if existed
    func value(for path: String) -> Any? {
        return Mirror(reflecting: self).children.first { $0.label == path }?.value
    }
}
