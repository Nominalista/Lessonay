//
// Created by Nominalista on 08.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

struct HomeMapper {

    private let lessonService = LessonService()

    func map(state: HomeState, input: ApplicationInput) -> (HomeState, Observable<ApplicationInput>?) {
        switch input {
        case let input as UpdateLessonStateInput:
            return map(state: state, input: input)
        default:
            return (state, nil)
        }
    }

    private func map(state: HomeState, input: UpdateLessonStateInput) -> (HomeState, Observable<ApplicationInput>?) {
        var output: Observable<ApplicationInput>?

        switch input.lessonState {
        case .loading:
            output = retrieveLesson()
        case .none, .failed, .lesson:
            output = .empty()
        }

        return (HomeState(lessonState: input.lessonState), output)
    }

    private func retrieveLesson() -> Observable<ApplicationInput> {
        return lessonService.retrieveLesson()
                .map { UpdateLessonStateInput(lessonState: .lesson($0)) }
    }
}