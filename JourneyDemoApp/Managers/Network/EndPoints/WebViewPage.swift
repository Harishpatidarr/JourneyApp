//
//  WebViewPage.swift
// 
//
//  Created byHarish Patidar on 7/9/18.
//  Copyright © 2018 Harish Patidar. All rights reserved.
//

import Foundation

// MARK: - BASE URL CONFIGURATION
enum WebView {
    case termsConditions
    
    var baseUrl: String {
        return AppHostURL.base
    }
    
    var url: String {
        switch self {
            case .termsConditions:
                return "\(AppHostURL.base)terms-conditions-app"
        }
    }
}
