//
// Created by Nominalista on 06.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

class AppTransducer: Transducer {

    private let lessonService = LessonService()

    func map(state: State, input: Input) -> (State, Observable<Input>)? {
        switch input {
        case .retrieveLessonRequested:
            return (State(), retrieveLesson())
        case .retrieveLessonDone(let lesson):
            return (State(lesson: lesson), .empty())
        case .retrieveLessonFailed(let error):
            print("Error has occurred: `\(error.localizedDescription)`.")
            return (State(), .empty())
        }
    }

    private func retrieveLesson() -> Observable<Input> {
        return lessonService.retrieveLesson()
                .map { lesson in Input.retrieveLessonDone(lesson) }
    }
}