//
// Created by Nominalista on 08.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

struct HomeMapper {

    typealias HomeMapperResult = (HomeState, Observable<ApplicationInput>?)

    private let lessonService = LessonService()

    func map(state: HomeState, input: HomeInput) -> HomeMapperResult {
        switch input {
        case let input as SetLessonStateInput:
            return setLessonState(state: state, input: input)
        default:
            return (state, nil)
        }
    }

    private func setLessonState(state: HomeState, input: SetLessonStateInput) -> HomeMapperResult {
        let output = input.lessonState == .loading ? loadLesson() : Observable.empty()
        let newState = HomeState(lessonState: input.lessonState)
        return (newState, output)
    }

    private func loadLesson() -> Observable<ApplicationInput> {
        return lessonService.loadLesson()
                .subscribeOn(BackgroundScheduler.instance)
                .observeOn(MainScheduler.instance)
                .map { SetLessonStateInput(lessonState: .lesson($0)) }
                .catchErrorJustReturn(SetLessonStateInput(lessonState: .failed))
    }
}