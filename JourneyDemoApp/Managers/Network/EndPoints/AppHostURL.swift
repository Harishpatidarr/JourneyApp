//
//  AppHostURL.swift
//  Harish
//
//  Created by Harish Patidar on 11/12/19.
//  Copyright © 2019 Harish Patidar. All rights reserved.
//

import Foundation

enum AppHostURL {
    private enum Domains {
        static let development = "https://jsonplaceholder.typicode.com"
    }
    
    private enum Routes {
        static let api = "/"
    }
    
    private static let domain = Domains.development
    private static let route = Routes.api
    static let base = domain + route
    
}
