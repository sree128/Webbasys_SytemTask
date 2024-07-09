//
//  API_Manager.swift
//  SystemTask
//
//  Created by Kanchireddy sreelatha on 08/07/24.
//

import Foundation
import UIKit

class ApiManager: NSObject {
    

    public class var instance: ApiManager {
        struct Singleton {
            static let obj = ApiManager()
        }
        return Singleton.obj
    }
    
    internal struct url {
    
        static let login = baseUrl.api + "/login"
        static let pets = baseUrl.api + "/user"
        static let product = baseUrl.api + "/sales?"
    }
    internal struct baseUrl {
        
        static let version1 = "/v1"
        static let api = "https://beta.yesdone.com/api" + version1
    }
    internal enum HTTPMethod: String {
        case get     = "GET"
        case post    = "POST"
    }

    func netWorkCall(baseUrl:String,  parameters : [String:String]?, methodType : HTTPMethod,token: String = "",page:Int?, per_page:Int=10, onCompletion: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        var _baseUrl = baseUrl
        if let page {
            _baseUrl = _baseUrl + "page=\(page)" + "&per_page=\(per_page)" + "&type=for-sale"
          //  print(_baseUrl)
        }
        let url = URL(string: _baseUrl)
        if url != nil {
            
            var request = URLRequest(url: url!)
            request.httpMethod = methodType.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            if methodType == .post{
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                    return
                }
                request.httpBody = httpBody
            }
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else { return }
                let httpResponse = response as! HTTPURLResponse
               
               

                            
                        onCompletion(data,response,error)

              
            }.resume()
        }
    }
    

}
