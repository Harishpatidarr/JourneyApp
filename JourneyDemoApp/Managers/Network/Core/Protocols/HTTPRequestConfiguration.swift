//
//
//
//  Created byHarish Patidar on 5/2/18.
//  Copyright © 2018Harish Patidar. All rights reserved.
//

import Foundation

protocol HTTPRequestConfiguration {
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethods { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var authorizationPolicy: HTTPAuthorizationPolicy { get }
    var encoding: ParameterEncodingType { get }
}
