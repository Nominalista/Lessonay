//
// Created by Nominalista on 03.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import Foundation

enum Input {

    case retrieveLessonRequested
    case retrieveLessonDone(Lesson)
    case retrieveLessonFailed(Error)
}