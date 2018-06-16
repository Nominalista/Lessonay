//
// Created by Nominalista on 08.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

enum LessonState: Equatable {

    case none
    case loading
    case failed
    case lesson(Lesson)

    static func ==(lhs: LessonState, rhs: LessonState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.loading, .loading):
            return true
        case (.failed, .failed):
            return true
        case (.lesson(let lhsLesson), .lesson(let rhsLesson)):
            return lhsLesson == rhsLesson
        default:
            return false
        }
    }
}

struct HomeState {

    var lessonState = LessonState.none
}

extension HomeState: Equatable {

    static func ==(lhs: HomeState, rhs: HomeState) -> Bool {
        return lhs.lessonState == rhs.lessonState
    }
}