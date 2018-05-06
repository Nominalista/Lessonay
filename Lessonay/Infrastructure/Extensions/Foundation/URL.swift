//
// Created by Nominalista on 02.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import Foundation

import Foundation

extension URL {

    var filename: String {
        let separated = absoluteString.components(separatedBy: "/")
        return separated.isEmpty ? "" : separated[separated.count - 1]
    }

    init?(string: String?) {
        guard let string = string else {
            return nil
        }
        self.init(string: string)
    }

    func with(scheme: String) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.scheme = scheme
        return components?.url
    }
}