import Foundation

extension Data {
    func dataToString() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    mutating func append<T>(value: T) {
        withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) in
            append(UnsafeBufferPointer(start: ptr, count: 1))
        }
    }
    
    func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return Data();
    }
    
    func dataToJSON() -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
        } catch let myJSONError {
            debugPrint(myJSONError)
        }
        return ""
    }
    
    func dataToModel<T: Codable>(parsingType: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: self)
        } catch {
            let err = error as! DecodingError
            switch err {
            case .typeMismatch(let key, let value):
                debugPrint("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .valueNotFound(let key, let value):
                debugPrint("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .keyNotFound(let key, let value):
                debugPrint("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .dataCorrupted(let key):
                debugPrint("error \(key), and ERROR: \(error.localizedDescription)")
            default:
                debugPrint("ERROR: \(error.localizedDescription)")
            }
            return nil
        }
    }
}
