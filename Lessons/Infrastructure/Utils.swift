//
// Created by Nominalista on 17.06.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import Foundation

func randomInt(_ upperBound: Int) -> Int {
    return Int(arc4random_uniform(UInt32(upperBound)))
}