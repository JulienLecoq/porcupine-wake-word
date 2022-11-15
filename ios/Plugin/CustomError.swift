//
//  CustomError.swift
//  Plugin
//
//  Created by Julien Lecoq on 28/08/2022.
//  Copyright © 2022 Max Lynch. All rights reserved.
//

import Foundation
import Capacitor

struct CustomError {
    let extra: [String: Any]?
    let code: String
    let message: String
    
    init(_ code: String, _ message: String, _ extra: [String: Any]? = nil) {
        self.code = code
        self.message = message
        self.extra = extra
    }
}

func reject(_ call: CAPPluginCall, _ error: CustomError) {
    call.reject(error.code, error.message)
}
