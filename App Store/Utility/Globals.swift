//
//  Globals.swift
//  App Store
//
//  Created by sathish on 08/06/20.
//  Copyright © 2020 sathish. All rights reserved.
//

import Foundation
import Alamofire

func getService(url: String, Headers : HTTPHeaders, parameters : NSDictionary, completion: @escaping ( _ result : NSDictionary) -> ()) {

    Alamofire.request(url, method: .get ,parameters: parameters as? Parameters, headers: Headers ).responseJSON { response in
        
        completion(parseToJSON(response))
    }
}

private func parseToJSON (_ response : DataResponse<Any>) -> NSDictionary {
    
    if let dict = response.result.value as? NSDictionary {
        return dict
    } else if let error = response.error {
        return ["Error":"\(error)"]
    } else {
        return ["Error":"Data parsing error!"]
    }
}
