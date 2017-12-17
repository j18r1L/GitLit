//
//  File.swift
//  GitLit
//
//  Created by Emil Astanov on 17.12.2017.
//  Copyright © 2017 Emil Astanov. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
