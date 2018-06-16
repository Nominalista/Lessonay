//
// Created by Nominalista on 06.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import Foundation

extension String {

    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}