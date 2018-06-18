//
// Created by Nominalista on 17.06.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import Foundation

extension Array {

    var random: Element? {
        if isEmpty {
            return nil
        } else {
            return self[randomInt(count)]
        }
    }
}