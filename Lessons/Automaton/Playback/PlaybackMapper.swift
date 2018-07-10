//
// Created by Nominalista on 08.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

struct PlaybackMapper {

    func map(state: PlaybackState, input: ApplicationInput) -> (PlaybackState, Observable<ApplicationInput>?) {
        switch input {
        case let input as SetIsPlayingInput:
            return map(state: state, input: input)
        case let input as SetLessonInput:
            return map(state: state, input: input)
        default:
            return (state, nil)
        }
    }

    private func map(state: PlaybackState, input: SetIsPlayingInput) -> (PlaybackState, Observable<ApplicationInput>?) {
        let newState = PlaybackState(isPlaying: input.isPlaying, lesson: state.lesson)
        return (newState, .empty())
    }

    private func map(state: PlaybackState, input: SetLessonInput) -> (PlaybackState, Observable<ApplicationInput>?) {
        let newState = PlaybackState(isPlaying: state.isPlaying, lesson: input.lesson)
        return (newState, .empty())
    }
}