//
//  ConnectAPI.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 8/06/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import Foundation
import Moya
import SwiftyUserDefaults

enum ConnectAPI {
    case authenticate(user:String, password:String)
    case employee(id:Int)
    case resetPassword(email:String)
    case createNewUser
}

extension ConnectAPI: TargetType {
    var baseURL: URL { return URL(string: "https://bxconnect.herokuapp.com:443")! }
    var path: String {
        switch self {
        case .authenticate:
            return "/api/employee/authenticate/"
        case .employee(let id):
            return "/api/employee/\(id)/"
        case .resetPassword(let email):
            return "/api/employee/reset/password/\(email)/"
        case .createNewUser:
            return "/api/employee/create/"
        }
    }
    var method: Moya.Method {
        switch self {
        case .authenticate:
            return .post
        case .employee, .resetPassword, .createNewUser:
            return .get
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .authenticate(let user, let password):
            return ["username":user, "password":password]
        case .employee, .resetPassword, .createNewUser:
            return nil
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .authenticate, .employee, .resetPassword, .createNewUser:
            return JSONEncoding.default
        }
    }
    var task: Task {
        switch self {
            case .authenticate, .employee, .resetPassword, .createNewUser:
            return .request
        }
    }
    var sampleData: Data {
        return Data()
    }
}

let endpointClosure = { (target: ConnectAPI) -> Endpoint<ConnectAPI> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    // Sign all non-authenticating requests
    switch target {
    case .employee:
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Token \(Defaults[.token])"])
    default:
        return defaultEndpoint
    }
}

