//
//  APIModel.swift
//  App Store
//
//  Created by sathish on 08/06/20.
//  Copyright © 2020 sathish. All rights reserved.
//

import UIKit
import Alamofire

class APIModel: NSObject {

    static let shared = APIModel()
    var list = [APIItem]()
    
    func process(completion: @escaping (_ model : APIModel)->()) {
        let headers: HTTPHeaders = [
            "x-api-key": "NEEDKEYHERE"
        ]
        getService(url: BASE_URL, Headers: headers, parameters: [:]) { (result) in
            if let responseArray = result.value(forKey: "card_data") as? NSArray {
                self.list.removeAll()
                for item in responseArray {
                    self.list.append(APIItem(item as! NSDictionary))
                }
            }
            completion(self)
        }
    }
    
}

class APIItem: NSObject {
    var content = ""
    var subtitle = ""
    var title = ""
    var url = ""
    
    override init() { }
    init(_ dict: NSDictionary) {
        self.content = dict.value(forKey: "content") as? String ?? ""
        self.subtitle = dict.value(forKey: "subtitle") as? String ?? ""
        self.title = dict.value(forKey: "title") as? String ?? ""
        self.url = dict.value(forKey: "url") as? String ?? ""
    }
}
