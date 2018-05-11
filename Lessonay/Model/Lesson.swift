//
// Created by Nominalista on 03.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import Foundation

struct Lesson {

    let videoURL: URL
}

extension Lesson: Equatable {

    static func ==(lhs: Lesson, rhs: Lesson) -> Bool {
        return lhs.videoURL == rhs.videoURL
    }
}