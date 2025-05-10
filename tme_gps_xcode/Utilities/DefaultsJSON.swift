import Foundation

struct DefaultsJSON {
    
    static func decode<T: Decodable>(from fileName: String, type: T.Type) -> T? {
       
        do {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                return nil
            }
            
            let result = try JSONDecoder().decode(T.self, from: data)
            
            return result
        } catch {
            print(error)
            return nil
        }

    }
}

