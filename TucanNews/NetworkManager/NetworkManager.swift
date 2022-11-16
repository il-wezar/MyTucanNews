//
//  NetworkManager.swift
//  TucanNews
//
//  Created by Illia Wezarino on 13.09.2022.
//

import UIKit


enum URLs: String {
    case news = "https://api.npoint.io/840884e6398c1c6fc5d3"
}

extension Request {
    
    class NetworkManager {
        
        static func fire(completion: @escaping ((NewsResponseObject) -> Void)) {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig,
                                     delegate: nil,
                                     delegateQueue: nil)
            
            guard let url = URL(string: URLs.news.rawValue) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if error == nil {
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    print("TRYING TO DECODE DATA:")
                    let decoder = JSONDecoder()
                    if let data = data {
                        do {
                            let decodedObject = try decoder.decode(NewsResponseObject.self, from: data)
                            completion(decodedObject)
                            print("DECODED \(NewsResponseObject.self) SUCCESSFULLY")
                            print(decodedObject)
                        } catch let DecodingError.dataCorrupted(context) {
                            print(context)
                        } catch let DecodingError.keyNotFound(key, context) {
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.valueNotFound(value, context) {
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.typeMismatch(type, context)  {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch {
                            print("error: ", error)
                        }
                    }
                } else {
                    print("URL Session Task Failed: %@", error!.localizedDescription)
                }
                log(response: response as? HTTPURLResponse, data: data, error: error)
            })
            task.resume()
            session.finishTasksAndInvalidate()
        }
    }
    
}
